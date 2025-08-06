const {spawn} = require('child_process');

// количество процессов для запуска
const processCount = 1000;

console.log(`Запускаем ${processCount} процессов...`);

for (let i = 1; i <= processCount; i++) {
    // создание дочернего процесса для выполнения PHP-скрипта
    const child = spawn('php', ['redis.php']);

    // вывод скрипта (stdout)
    child.stdout.on('data', (data) => {
        process.stdout.write(`[${i}] ${data}`);
    });
    
    // ошибки скрипта (stdout)
    child.stderr.on('data', (data) => {
        process.stderr.write(`[${i}-ERROR] ${data}`);
    });
}

console.log('Все процессы запущены');