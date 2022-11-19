from markdown_subtemplate import storage,engine

storage.file_storage.FileStore.set_template_folder("/home/jose/Documents/dd")

data = {'variable1': 'Value 1', 'variable2': 'Value 2'}
contents = engine.get_page('page.md', data)




