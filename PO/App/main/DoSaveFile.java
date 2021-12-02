package ggc.app.main;

import ggc.app.GGCCommand;
import ggc.core.WarehouseManager;
import ggc.core.exception.MissingFileAssociationException;

import java.io.IOException;
import pt.tecnico.uilib.forms.Form;

/**
 * Save current state to file under current name (if unnamed, query for name).
 */
final class DoSaveFile extends GGCCommand {
  /** @param receiver */
  DoSaveFile(WarehouseManager receiver) {
    super(Label.SAVE, receiver);
  }

  @Override
  protected void doExecute() throws IOException, MissingFileAssociationException {
    if (!_receiver.hasFilename()) {
      Form form = new Form();
      form.addStringField("filename", Message.newSaveAs());
      form.parse();
      _receiver.saveAs(form.stringField("filename")); 
      return;
    }
    _receiver.save();
  }
}
