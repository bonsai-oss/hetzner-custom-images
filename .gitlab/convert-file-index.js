const fs = require('fs');
const path = require('path');


// Get the file path from the command line arguments
const filePath = process.argv[2];

// Check if file path is provided
if (!filePath) {
    console.error('Please provide a file path as the first argument.');
    process.exit(1);
}

// Read the JSON data from the file
fs.readFile(filePath, 'utf8', (err, data) => {
    if (err) {
        console.error(`Error reading file from disk: ${err.message}`);
        process.exit(1);
    }

    // Parse the JSON data
    let jsonData;
    try {
        jsonData = JSON.parse(data);
    } catch (parseErr) {
        console.error(`Error parsing JSON data: ${parseErr.message}`);
        process.exit(1);
    }

    // Function to format file size in a readable format
    function formatFileSize(bytes) {
        const units = ['B', 'KB', 'MB', 'GB', 'TB'];
        let unitIndex = 0;
        while (bytes >= 1024 && unitIndex < units.length - 1) {
            bytes /= 1024;
            unitIndex++;
        }
        return `${bytes.toFixed(2)} ${units[unitIndex]}`;
    }

    jsonData = jsonData.filter(item => item.Name !== 'index.html');

    // Generate HTML content
    const htmlContent = `
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>S3 Bucket Listing</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ddd;
            text-align: left;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h1>File Listing</h1>
    <table>
        <tr>
            <th>Branch</th>
            <th>Name</th>
            <th>Size</th>
            <th>Last Modified</th>
        </tr>
        ${jsonData.map(item => `
            <tr>
                <td>${path.dirname(item.Path)}</td>
                <td><a href="${item.Path}">${item.Name}</a></td>
                <td>${formatFileSize(item.Size)}</td>
                <td>${new Date(item.ModTime).toLocaleString()}</td>
            </tr>
        `).join('')}
    </table>
</body>
</html>
`;

    // Write HTML content to index.html
    fs.writeFile('index.html', htmlContent, writeErr => {
        if (writeErr) {
            console.error(`Error writing to file: ${writeErr.message}`);
            process.exit(1);
        }
        console.log('index.html has been saved!');
    });
});