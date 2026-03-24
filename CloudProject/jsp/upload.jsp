<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Upload Files</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
.drop-zone {
    border: 2px dashed #0d6efd;
    padding: 30px;
    text-align: center;
    background-color: #f8f9fa;
    cursor: pointer;
    transition: 0.3s;
}

.drop-zone.dragover {
    background-color: #e9f2ff;
    border-color: #0a58ca;
}

.file-list {
    font-size: 14px;
    margin-top: 10px;
}
</style>

<script>
function dragOverHandler(ev) {
    ev.preventDefault();
    document.querySelector('.drop-zone').classList.add('dragover');
}

function dragLeaveHandler() {
    document.querySelector('.drop-zone').classList.remove('dragover');
}

function dropHandler(ev) {
    ev.preventDefault();
    const dropZone = document.querySelector('.drop-zone');
    dropZone.classList.remove('dragover');

    const fileInput = document.getElementById("fileInput");
    fileInput.files = ev.dataTransfer.files;

    showFileNames(fileInput.files);
}

function showFileNames(files) {
    let list = document.getElementById("fileList");
    list.innerHTML = "";

    for (let i = 0; i < files.length; i++) {
        let item = document.createElement("div");
        item.textContent = "📄 " + files[i].name;
        list.appendChild(item);
    }
}

function handleFileSelect(input) {
    showFileNames(input.files);
}

window.onload = function() {
    document.getElementById("uploadForm").addEventListener("submit", function() {
        document.getElementById("uploadBtn").disabled = true;
        document.getElementById("loading").style.display = "block";
    });
};
</script>

</head>

<body class="bg-light">

<div class="container mt-5">

    <div class="row justify-content-center">

        <div class="col-md-6">

            <div class="card shadow p-4">

                <h3 class="text-center mb-4">Upload Files 📂</h3>

                <form id="uploadForm" action="<%=request.getContextPath()%>/upload" method="post" enctype="multipart/form-data">

                    <!-- 🔥 Drag & Drop -->
                    <div class="drop-zone mb-3"
                         ondrop="dropHandler(event)"
                         ondragover="dragOverHandler(event)"
                         ondragleave="dragLeaveHandler()">

                        <p>Drag & Drop Files Here 📂</p>
                        <p>or</p>

                        <input type="file" id="fileInput" name="file" multiple class="form-control"
                               onchange="handleFileSelect(this)">
                    </div>

                    <!-- 🔥 Selected files list -->
                    <div id="fileList" class="file-list text-muted"></div>

                    <!-- 🔥 Upload button -->
                    <div class="d-grid mt-3">
                        <button type="submit" class="btn btn-primary" id="uploadBtn">
                            Upload 🚀
                        </button>
                    </div>

                    <!-- 🔥 Loading spinner -->
                    <div id="loading" class="text-center mt-3" style="display:none;">
                        <div class="spinner-border text-primary"></div>
                        <p>Uploading... Please wait ⏳</p>
                    </div>

                </form>

                <div class="text-center mt-3">
                    <a href="home.jsp">⬅ Back to Home</a>
                </div>

            </div>

        </div>

    </div>

</div>

</body>
</html>