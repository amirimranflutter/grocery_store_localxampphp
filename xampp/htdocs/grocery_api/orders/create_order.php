<?php
error_reporting(0);
ini_set('display_errors', 0);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

require_once __DIR__ . '/../config/db_connection.php';

$conn = getDBConnection();

// Get JSON data from request
$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['items']) || empty($data['items'])) {
    echo json_encode([
        "status" => "error",
        "message" => "No items in order"
    ]);
    exit;
}

// Extract order data
$customer_id = isset($data['customer_id']) ? intval($data['customer_id']) : null;
$emp_id = isset($data['emp_id']) ? intval($data['emp_id']) : null;
$total_amount = floatval($data['total_amount']);
$discount_amount = floatval($data['discount_amount'] ?? 0);
$tax_amount = floatval($data['tax_amount'] ?? 0);
$final_amount = floatval($data['final_amount']);
$payment_method = $data['payment_method'] ?? 'cash';
$order_status = $data['order_status'] ?? 'completed';
$items = $data['items'];

// Start transaction
$conn->begin_transaction();

try {
    // 1. Insert into orders table
    $stmt = $conn->prepare("INSERT INTO orders (customer_id, emp_id, total_amount, discount_amount, tax_amount, final_amount, payment_method, order_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("iiddddss", $customer_id, $emp_id, $total_amount, $discount_amount, $tax_amount, $final_amount, $payment_method, $order_status);
    
    if (!$stmt->execute()) {
        throw new Exception("Failed to create order: " . $stmt->error);
    }
    
    $order_id = $conn->insert_id;

    // 2. Insert order items and update stock
    $stmt_items = $conn->prepare("INSERT INTO order_items (order_id, p_id, quantity, unit_price, subtotal) VALUES (?, ?, ?, ?, ?)");
    $stmt_stock = $conn->prepare("UPDATE products SET stock = stock - ? WHERE p_id = ?");
    
    foreach ($items as $item) {
        $p_id = intval($item['p_id']);
        $quantity = intval($item['quantity']);
        $unit_price = floatval($item['unit_price']);
        $subtotal = floatval($item['subtotal']);
        
        // Insert order item
        $stmt_items->bind_param("iiidd", $order_id, $p_id, $quantity, $unit_price, $subtotal);
        if (!$stmt_items->execute()) {
            throw new Exception("Failed to add order item: " . $stmt_items->error);
        }
        
        // Update product stock
        $stmt_stock->bind_param("ii", $quantity, $p_id);
        if (!$stmt_stock->execute()) {
            throw new Exception("Failed to update stock: " . $stmt_stock->error);
        }
        
        // Insert inventory transaction
        $stmt_inv = $conn->prepare("INSERT INTO inventory_transactions (p_id, transaction_type, quantity, previous_stock, new_stock, emp_id, reference_id) SELECT p_id, 'sale', ?, stock + ?, stock, ?, ? FROM products WHERE p_id = ?");
        $stmt_inv->bind_param("iiiii", $quantity, $quantity, $emp_id, $order_id, $p_id);
        $stmt_inv->execute();
    }

    // 3. Insert payment transaction
    $transaction_ref = 'TXN-' . $order_id . '-' . date('Y');
    $stmt_payment = $conn->prepare("INSERT INTO payment_transactions (order_id, payment_method, amount, payment_status, transaction_reference) VALUES (?, ?, ?, 'completed', ?)");
    $stmt_payment->bind_param("isds", $order_id, $payment_method, $final_amount, $transaction_ref);
    
    if (!$stmt_payment->execute()) {
        throw new Exception("Failed to record payment: " . $stmt_payment->error);
    }

    // 4. Update customer total purchases if customer exists
    if ($customer_id) {
        $stmt_customer = $conn->prepare("UPDATE customers SET total_purchases = total_purchases + ?, last_purchase_date = NOW() WHERE customer_id = ?");
        $stmt_customer->bind_param("di", $final_amount, $customer_id);
        $stmt_customer->execute();
    }

    // Commit transaction
    $conn->commit();

    echo json_encode([
        "status" => "success",
        "message" => "Order created successfully",
        "order_id" => $order_id,
        "transaction_reference" => $transaction_ref
    ]);

} catch (Exception $e) {
    // Rollback on error
    $conn->rollback();
    
    echo json_encode([
        "status" => "error",
        "message" => $e->getMessage()
    ]);
}

$conn->close();
?>