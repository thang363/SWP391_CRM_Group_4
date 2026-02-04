package model.entity;

import java.sql.Timestamp;

public class Attachment {
    private int id;
    private String fileName;
    private String filePath;
    private long fileSize;
    private Integer uploadedBy;
    private String relatedToEntity;
    private Integer relatedRecordId;
    private Timestamp createdAt;

    public Attachment() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public long getFileSize() {
        return fileSize;
    }

    public void setFileSize(long fileSize) {
        this.fileSize = fileSize;
    }

    public Integer getUploadedBy() {
        return uploadedBy;
    }

    public void setUploadedBy(Integer uploadedBy) {
        this.uploadedBy = uploadedBy;
    }

    public String getRelatedToEntity() {
        return relatedToEntity;
    }

    public void setRelatedToEntity(String relatedToEntity) {
        this.relatedToEntity = relatedToEntity;
    }

    public Integer getRelatedRecordId() {
        return relatedRecordId;
    }

    public void setRelatedRecordId(Integer relatedRecordId) {
        this.relatedRecordId = relatedRecordId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
