<?php
// создание экземпляра redis-клиента
$redis = new Redis();
$redis->connect('127.0.0.1', 6379);

// Ключ для блокировки
$lockKey = 'process_lock';
// Уникальный идентификатор процесса
$identifier = uniqid();
// секунды, сколько живёт блокировка
$timeout = 3;
// NX - только если ключ не существует
// EX - время автоматического удаления блокировки
$isLocked = $redis->set($lockKey, $identifier, ['NX', 'EX' => $timeout]);

// eсли не удалось получить блокировку
if (!$isLocked) {
    echo "[$identifier] Ошибка: Процесс уже выполняется\n";
    exit(1);
}

echo "Запуск процесса $identifier\n";

sleep(1);

echo "Завершение процесса $identifier\n";

// удаление, если значение всё ещё равно нашему идентификатору
if ($redis->get($lockKey) === $identifier) {
    $redis->del($lockKey);
}
