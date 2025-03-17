const fs = require('fs').promises;
const path = require('path');

class CLschedule{
    async getCLData(){
        try{
            const filePath = path.join(__dirname, '..', 'data', 'commuterLineSchedule.txt');
            const data = await fs.readFile(filePath, 'utf8');
            const line = data.trim().split('\n');
            const header = line[0].split('\t');
            const schedule = line.slice(1).map(line => {
                const values = line.split('\t');
                let obj = {};
                headers.forEach((header, idx) => {
                    obj[header] = values[idx];
                })
                return obj;
            })
            return schedule;
        } catch (error) {
            console.error('Error reading schedule file', error.message);
            throw error;
        }
    }
}

module.exports = new CLschedule();