package ggc.app;

import java.io.IOException;

import ggc.app.exception.DuplicatePartnerKeyException;
import ggc.app.exception.FileOpenFailedException;
import ggc.app.exception.InvalidDateException;
import ggc.app.exception.UnavailableProductException;
import ggc.app.exception.UnknownPartnerKeyException;
import ggc.app.exception.UnknownProductKeyException;
import ggc.app.exception.UnknownTransactionKeyException;
import ggc.core.WarehouseManager;
import ggc.core.exception.DuplicatePartnerException;
import ggc.core.exception.InsufficientStockException;
import ggc.core.exception.MissingFileAssociationException;
import ggc.core.exception.NegativeDaysException;
import ggc.core.exception.NoSuchPartnerException;
import ggc.core.exception.NoSuchProductException;
import ggc.core.exception.NoSuchTransactionException;
import ggc.core.exception.UnavailableFileException;
import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;

public abstract class GGCCommand extends Command<WarehouseManager> {
    public GGCCommand(String title, WarehouseManager receiver) {
        super(title, receiver);
    }
    
    @Override
    protected void execute() throws CommandException {
        try {
            doExecute();
        }
        catch (DuplicatePartnerException e) {
            throw new DuplicatePartnerKeyException(e.getIdentifier());
        }
        catch (InsufficientStockException e) {
            throw new UnavailableProductException(e.getProduct(), e.getRequested(), e.getAvailable());
        }
        catch (IOException e) {
            throw new FileOpenFailedException(_receiver.getFilename());
        }
        catch (MissingFileAssociationException e) {
            e.printStackTrace();
        }
        catch (NegativeDaysException e) {
            throw new InvalidDateException(e.getDays());
        }
        catch (NoSuchPartnerException e) {
            throw new UnknownPartnerKeyException(e.getIdentifier());
        }
        catch (NoSuchProductException e) {
            throw new UnknownProductKeyException(e.getIdentifier());
        }
        catch (NoSuchTransactionException e) {
            throw new UnknownTransactionKeyException(e.getIdentifier());
        }
        catch (UnavailableFileException e) {
            throw new FileOpenFailedException(e.getFilename());
        }
    }

    protected abstract void doExecute() throws DuplicatePartnerException,
        InsufficientStockException, IOException, MissingFileAssociationException,
        NegativeDaysException, NoSuchPartnerException,
        NoSuchProductException, NoSuchTransactionException, UnavailableFileException;
}
