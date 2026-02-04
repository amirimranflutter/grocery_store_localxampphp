<?php
// Script to add CORS headers to all PHP API files

$corsHeaders = '<?php
error_reporting(0);
ini_set(\'display_errors\', 0);

// Handle CORS for web browsers
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Content-Type: application/json; charset=UTF-8");

// Handle preflight OPTIONS request
if ($_SERVER[\'REQUEST_METHOD\'] === \'OPTIONS\') {
    http_response_code(200);
    exit();
}
';

$directories = [
    'products',
    'customers',
    'orders',
    'cart',
    'staff',
    'suppliers',
    'reports'
];

echo "Adding CORS headers to API files...\n\n";

foreach ($directories as $dir) {
    if (!is_dir($dir)) continue;
    
    $files = glob("$dir/*.php");
    foreach ($files as $file) {
        echo "Processing: $file\n";
        
        $content = file_get_contents($file);
        
        // Skip if already has CORS headers
        if (strpos($content, 'Access-Control-Allow-Methods') !== false) {
            echo "  ✓ Already has CORS headers\n";
            continue;
        }
        
        // Remove old headers and add new ones
        $content = preg_replace('/^<\?php\s*\n/', '', $content);
        $content = preg_replace('/^(error_reporting.*?\n)/', '', $content);
        $content = preg_replace('/^(ini_set.*?\n)/', '', $content);
        $content = preg_replace('/^(header\(.*?\);\s*\n)+/m', '', $content);
        
        $newContent = $corsHeaders . "\n" . ltrim($content);
        
        file_put_contents($file, $newContent);
        echo "  ✓ Updated\n";
    }
}

echo "\n✓ CORS headers added to all API files!\n";
?>
