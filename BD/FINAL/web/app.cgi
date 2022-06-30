#!/usr/bin/python3
from crypt import methods
from wsgiref.handlers import CGIHandler 
from flask import Flask, redirect, render_template, request
import psycopg2
import psycopg2.extras

DB_HOST="db.tecnico.ulisboa.pt"
DB_USER="" 
DB_DATABASE=DB_USER
DB_PASSWORD=""
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (DB_HOST, DB_DATABASE, DB_USER, DB_PASSWORD)

def log(content):
    with open("oops.txt", "a+") as f:
        f.write(str(content) + "\n")


class DBClient:
    def __init__(self) -> None:
        try:
            self.dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        except Exception as e: 
            log("Connection error: " + str(e))
            return str(e)

    def queryWrapper(self, query, values):
        cursor = self.dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
        try:
            if values:
                res = cursor.execute(query, values)
                if "SELECT" in query:
                    return cursor.fetchall()
                else:
                    return res
            else:
                res = cursor.execute(query)
                if "SELECT" in query:
                    return cursor.fetchall()
                else:
                    return res
        except Exception as e: 
            log("Query error: " + str(e))
            raise Exception("Query error: " + str(e))
        finally:
            cursor.close()

    def renderPageForQueries(self, page, queries):
        cursors = {}
        try:
            for context in queries:
                log("Parsing context: " + context)
                cursors[context] = self.dbConn.cursor(cursor_factory = psycopg2.extras.DictCursor)
                # Verificar se a query tem valores fornecidos
                if type(queries[context]) is dict:
                    if queries[context]["query"] == "CONTEXT_NOT_QUERY":
                        log(context + " -> ONLY CONTEXT")
                        cursors[context] = queries[context]["values"]
                    else:
                        log(context + " -> QUERY WITH VALUES")
                        cursors[context].execute(queries[context]["query"], queries[context]["values"])
                else:
                    log(context + " -> QUERY")
                    cursors[context].execute(queries[context])

            return render_template(page, **cursors)
        except Exception as e: 
            log("Query error: " + str(e))
            return str(e)
        finally:
            for cursor in cursors:
                try:
                    cursors[cursor].close()
                except Exception as e:
                    log("[CURSOR CLOSE] Probably not a cursor, ignore")
            self.close()

    def commit(self):
        self.dbConn.commit()

    def close(self):
        self.dbConn.close()



app = Flask(__name__);
db_client = DBClient()

@app.route("/")
def index():

    # Links
    query_categorias = "SELECT * FROM categoria ORDER BY categoria.nome ASC"
    category_path = ""
    current_ivm = ""


    if request.args.get("cat"):

        category_path = request.args.get("cat")
        category_path_list = category_path.split("/")

        if len(category_path_list) != 0 and category_path_list[-1] != "":
            query_categorias = {
                "query": "SELECT tem_outra.nome_categoria FROM tem_outra WHERE tem_outra.nome_super_categoria=%s",
                "values": (category_path_list[-1], )
            }


    query_eventos = {
        "query": "CONTEXT_NOT_QUERY",
        "values": None
    }
    if request.args.get("ivm"):
        current_ivm = request.args.get("ivm")
        query_eventos = {
            "query": "SELECT produto.cat, SUM(evento_reposicao.unidades) FROM evento_reposicao NATURAL JOIN produto WHERE evento_reposicao.num_serie =%s AND evento_reposicao.fabricante =%s GROUP BY produto.cat ORDER BY produto.cat DESC",
            "values": tuple(current_ivm.split("-", 1))
        }

    queries = {
        "categorias": query_categorias,
        "retalhistas": "SELECT retalhista.nome FROM retalhista",
        "ivms": "SELECT COUNT(*) AS evt_count, evento_reposicao.num_serie, evento_reposicao.fabricante FROM evento_reposicao GROUP BY evento_reposicao.num_serie, evento_reposicao.fabricante ORDER BY evt_count DESC",
        "eventos": query_eventos,
        "base_url": {
            "query": "CONTEXT_NOT_QUERY",
            "values": request.base_url
        },
        "category_path": {
            "query": "CONTEXT_NOT_QUERY",
            "values": category_path
        },
        "current_ivm": {
            "query": "CONTEXT_NOT_QUERY",
            "values": ("&ivm=" + current_ivm if current_ivm != "" else "" )
        },
        "errors": {
            "query": "CONTEXT_NOT_QUERY",
            "values": request.args.get("errors")
        },
    }
    return db_client.renderPageForQueries("index.html", queries)

@app.route("/delete_cat")
def delete_cat():
    # First get required info
    if request.args.get("cat"):
        category_delete_path = request.args.get("cat").split("/")
    else:
        return "<h2>Error: Missing args</h2>"

    log("Delete path: " + request.args.get("cat"))

    category_to_delete = category_delete_path[-1]

    log("CAT DEL: " + category_to_delete)

    errors = ""
    try:
        # Delete relations
        db_client.queryWrapper("DELETE FROM tem_outra WHERE tem_outra.nome_super_categoria = %s OR tem_outra.nome_categoria = %s", (category_to_delete, category_to_delete,))
        # Delete from responsavel_por
        db_client.queryWrapper("DELETE FROM responsavel_por WHERE responsavel_por.nome_cat = %s", (category_to_delete,))
        # Delete from super-categorias
        db_client.queryWrapper("DELETE FROM super_categoria WHERE super_categoria.nome = %s", (category_to_delete,))
        # Delete from simple-categorias
        db_client.queryWrapper("DELETE FROM categoria_simples WHERE categoria_simples.nome = %s", (category_to_delete,))
        # Delete from categorias
        db_client.queryWrapper("DELETE FROM categoria WHERE categoria.nome = %s", (category_to_delete,))
        
        db_client.commit()

    except Exception as e:
        errors = "&errors=" + str(e)
    finally:
        db_client.close()

    
    return redirect(request.base_url.replace("delete_cat", "?cat=") + "/".join(category_delete_path[0:-1]) + errors)

@app.route("/add_cat", methods=["POST"])
def add_cat():

    # First get required info
    if request.args.get("cat") and request.form["categoria"]:
        category_add_path = request.args.get("cat").split("/")
        new_category_name = request.form.get("categoria")
    else:
        return "<h2>Error: Missing args</h2>"

    parent_category = category_add_path[-2]

    log("ADD CAT PATH: " + request.args.get("cat"))
    log("PARENT: " + parent_category)
    log("NEW CAT NAME: " + new_category_name)

    errors = ""
    try:

        if parent_category != "":
            # Delete from simple catgories
            db_client.queryWrapper("DELETE FROM categoria_simples WHERE categoria_simples.nome = %s", (parent_category, ))

            # Check if parent is already inserted
            result = db_client.queryWrapper("SELECT * FROM super_categoria WHERE super_categoria.nome = %s", (parent_category, ))

            if len(result) == 0:
                db_client.queryWrapper("INSERT INTO super_categoria VALUES (%s)", (parent_category, ))

        db_client.queryWrapper("INSERT INTO categoria VALUES (%s)", (new_category_name,))

        db_client.queryWrapper("INSERT INTO categoria_simples VALUES (%s)", (new_category_name,))


        if parent_category != "":
            db_client.queryWrapper("INSERT INTO tem_outra VALUES (%s, %s)", (parent_category, new_category_name, ))
    
        db_client.commit()

    except Exception as e:
        errors = "&errors=" + str(e)
    finally:
        db_client.close()

    return redirect(request.base_url.replace("add_cat", "?cat=") + "/".join(category_add_path[0:-1]) + errors)


@app.route("/delete_ret")
def delete_ret():
        # First get required info
    if request.args.get("ret"):
        retailer_delete = request.args.get("ret")
    else:
        return "<h2>Error: Missing args</h2>"

    log("Delete retailer: " + retailer_delete)

    errors = ""
    try:
        # Delete relations
        result = db_client.queryWrapper("SELECT retalhista.tin FROM retalhista WHERE retalhista.nome = %s", (retailer_delete, ))

        if len(result) > 0:
            tin = int(result[0][0])

            log("Got TIN: " + str(tin))

            # Delete responsavel_por
            db_client.queryWrapper("DELETE FROM responsavel_por WHERE responsavel_por.tin = %s", (tin, )) 

            # Delete from evento reposicao
            db_client.queryWrapper("DELETE FROM evento_reposicao WHERE evento_reposicao.tin = %s", (tin, )) 

            # Delete retailer
            db_client.queryWrapper("DELETE FROM retalhista WHERE retalhista.nome =  %s", (retailer_delete, )) 

            db_client.commit()

    except Exception as e:
        errors = "?errors=" + str(e)
    finally:
        db_client.close()

    
    return redirect(request.base_url.replace("delete_ret", "") + errors)

@app.route("/add_ret", methods=["POST"])
def add_ret():

    # First get required info
    if request.form.get("retalhista"):
        new_retailer = request.form.get("retalhista")
    else:
        return "<h2>Error: Missing args</h2>"

    log("ADD RET: " + new_retailer)

    errors = ""
    try:

        result = db_client.queryWrapper("SELECT max(retalhista.tin) FROM retalhista", None)

        if len(result) > 0:
            tin = int(result[0][0]) + 1

            db_client.queryWrapper("INSERT INTO retalhista VALUES (%s, %s)", (tin, new_retailer, ))

            db_client.commit()

    except Exception as e:
        errors = "?errors=" + str(e)
    finally:
        db_client.close()

    return redirect(request.base_url.replace("add_ret", "") + errors)


app.debug = True
CGIHandler().run(app)
