package dao;

import model.entity.Attachment;
import java.util.List;

public interface AttachmentDAO {
    boolean saveAttachment(Attachment attachment);

    List<Attachment> getByEntityAndRecordId(String entity, int recordId);
}
