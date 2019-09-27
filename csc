#!/usr/bin/php
<?php

// Получаем список аргументов
$arguments = $argv;

// Получаем файл с текстом (Он всегда будет последним аргументом)
$inputFile = $argv[count($arguments)-1];


// Получаем список файлов в которые необходимо будет положить результаты
    // Если в команде есть символы '&&' то это будет означать что мы перечисляем список файлов и их форматов.
    // В которые нужно будет записать результат
    // Отфильтруем массив аргументов таким образом, что бы получить только список файлов в который необходимо будет положить результат.
    // Для этого мы исключим из массива [индекс(0), $inputFile, и символы "&&" ];
$outputFiles = array_filter($arguments, function($value, $key) use ($inputFile) {
    return $key !== 0 && $value !== $inputFile && $value !== "&&";
}, ARRAY_FILTER_USE_BOTH);



try {
    // Прочитаем данные из inputFile 
    // Преобразуем все слова в нижний регистр так как array_count_values регистрозависимая функция.
    // Преобразуем в массив для дальнейшего подсчета элементов в массиве.
    $currentDir = __DIR__;
    $filePath = "{$currentDir}/{$inputFile}";
    $fileContent = explode(" ", strtolower(file_get_contents($filePath)));

    // Подсчитываем
    $countsResult = array_count_values($fileContent);

    //Подготовка визуального оформления текста
    $pretty = implode("\n", array_map(
        function ($v, $k) { return sprintf("%s %s", $k, $v); },
        $countsResult,
        array_keys($countsResult)
    ));

    // Записываем данные в результирующие файлы.
    array_map(function($file) use ($pretty) { 
        file_put_contents($file, $pretty);
    }, $outputFiles );

    // Вывод результата на экран консоли
    echo $pretty;

}catch(Exeption $e) {
    throw new Error("Файл не найден!");
}
