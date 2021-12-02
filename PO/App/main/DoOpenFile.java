package ggc.app.main;

import ggc.app.GGCCommand;
import ggc.core.WarehouseManager;
import ggc.core.exception.UnavailableFileException;

/**
 * Open existing saved state.
 */
final class DoOpenFile extends GGCCommand {
  /** @param receiver */
  DoOpenFile(WarehouseManager receiver) {
    super(Label.OPEN, receiver);
    addStringField("filename", Message.openFile());
  }

  @Override
  protected void doExecute() throws UnavailableFileException {
    try {
      String filename = stringField("filename");
      _receiver.load(filename);
    }
    catch (ClassNotFoundException e) {
      e.printStackTrace();
    }
  }
}
