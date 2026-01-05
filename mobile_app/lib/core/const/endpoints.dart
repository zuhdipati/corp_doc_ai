String baseUrl = 'http://127.0.0.1:8000/api/v1';

String urlGetDocuments = '$baseUrl/documents';
String urlDeleteDocument(String documentId) => '$baseUrl/documents/$documentId';
String urlUploadDocuments = '$baseUrl/documents/upload';
String urlGetDocumentDetail(String documentId) =>
    '$baseUrl/documents/$documentId';

String urlSendMessage = '$baseUrl/chat/send';
String urlGetChatHistory(String documentId, String limit, String beforeId) =>
    '$baseUrl/chat/history?document_id=$documentId&limit=$limit&before_id=$beforeId';
