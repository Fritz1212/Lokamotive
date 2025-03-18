const fs = require('fs').promises;
const path = require('path');

class CLschedule {
    async getCLData() {
        try {
            const filePath = path.join(__dirname, 'commuterLineSchedule.txt');
            const data = await fs.readFile(filePath, 'utf8');

            // Trim, split lines, and remove carriage returns
            const lines = data.trim().split('\n').map(line => line.replace(/\r/g, ''));

            if (lines.length < 2) {
                throw new Error('Invalid file format');
            }

            // Extract headers and clean up spaces
            const headers = lines[0].split('|').map(h => h.trim());

            // Parse each line into an object
            const schedule = lines.slice(1).map(line => {
                const values = line.split('|').map(v => v.trim());
                let obj = {};

                headers.forEach((header, idx) => {
                    obj[header] = values[idx] || null; // Handle missing values
                });

                return obj;
            });

            return schedule;
        } catch (error) {
            console.error('Error reading schedule file:', error.message);
            throw error;
        }
    }
}

module.exports = new CLschedule();