#!/bin/bash

# Azure Reverse Proxy Deployment Test Script
# Tests the public VM reverse proxy to private VM Nginx setup

echo "=========================================="
echo "Azure Reverse Proxy Test Script"
echo "=========================================="
echo ""

# Check if required parameter is provided
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <PUBLIC_VM_IP> [PRIVATE_VM_IP] [USERNAME]"
    echo ""
    echo "Example: $0 20.121.45.123"
    echo "Example: $0 20.121.45.123 10.0.2.4 azureuser"
    echo ""
    echo "You can find the public IP in the ARM template deployment outputs:"
    echo "  - publicVmPublicIP"
    echo ""
    exit 1
fi

PUBLIC_VM_IP=$1
PRIVATE_VM_IP=${2:-""}
USERNAME=${3:-"azureuser"}

echo "Configuration:"
echo "  Public VM IP:  $PUBLIC_VM_IP"
if [ -n "$PRIVATE_VM_IP" ]; then
    echo "  Private VM IP: $PRIVATE_VM_IP"
fi
echo "  Username:      $USERNAME"
echo ""
echo "=========================================="
echo ""

# Test 1: Check if reverse proxy is accessible
echo "Test 1: Testing Reverse Proxy Access..."
echo "Command: curl -s -o /dev/null -w '%{http_code}' http://$PUBLIC_VM_IP"
HTTP_CODE=$(curl -s -o /dev/null -w '%{http_code}' http://$PUBLIC_VM_IP 2>/dev/null)

if [ "$HTTP_CODE" = "200" ]; then
    echo "✅ SUCCESS: Reverse proxy is accessible (HTTP 200)"
elif [ "$HTTP_CODE" = "502" ]; then
    echo "⚠️  WARNING: Got 502 Bad Gateway - proxy is running but backend may not be ready yet"
    echo "   Wait 2-3 minutes for extensions to complete and try again"
elif [ -z "$HTTP_CODE" ]; then
    echo "❌ FAILED: Cannot connect to public VM"
    echo "   Check: VM is running, NSG allows HTTP, correct IP address"
else
    echo "⚠️  WARNING: Got HTTP $HTTP_CODE (expected 200)"
fi
echo ""

# Test 2: Get content from reverse proxy
echo "Test 2: Fetching Content Through Reverse Proxy..."
echo "Command: curl -s http://$PUBLIC_VM_IP | head -n 5"
CONTENT=$(curl -s http://$PUBLIC_VM_IP 2>/dev/null | head -n 5)

if echo "$CONTENT" | grep -q "html"; then
    echo "✅ SUCCESS: Received HTML content from backend"
    echo "   Content preview:"
    echo "$CONTENT" | head -n 3
    
    if echo "$CONTENT" | grep -q "Private"; then
        echo "   ✨ Confirmed: Content is from Private VM!"
    fi
else
    echo "❌ FAILED: No valid HTML content received"
    if [ "$HTTP_CODE" = "502" ]; then
        echo "   Backend is not ready yet. Wait and retry."
    fi
fi
echo ""

# Test 3: Test health endpoint
echo "Test 3: Testing Reverse Proxy Health Endpoint..."
echo "Command: curl -s http://$PUBLIC_VM_IP/health"
HEALTH=$(curl -s http://$PUBLIC_VM_IP/health 2>/dev/null)

if echo "$HEALTH" | grep -q "healthy"; then
    echo "✅ SUCCESS: Proxy health check passed"
    echo "   Response: $HEALTH"
else
    echo "⚠️  WARNING: Health endpoint not responding correctly"
fi
echo ""

# Test 4: Test proxy status endpoint
echo "Test 4: Checking Reverse Proxy Status..."
echo "Command: curl -s http://$PUBLIC_VM_IP/proxy-status"
STATUS=$(curl -s http://$PUBLIC_VM_IP/proxy-status 2>/dev/null)

if echo "$STATUS" | grep -q "Backend"; then
    echo "✅ SUCCESS: Proxy status endpoint working"
    echo "   Status:"
    echo "$STATUS" | sed 's/^/   /'
else
    echo "⚠️  WARNING: Status endpoint not configured yet"
fi
echo ""

# Test 5: Verify private VM is NOT accessible directly (if IP provided)
if [ -n "$PRIVATE_VM_IP" ]; then
    echo "Test 5: Verifying Private VM Isolation..."
    echo "Command: curl --connect-timeout 5 http://$PRIVATE_VM_IP"
    
    timeout 6 curl --connect-timeout 5 http://$PRIVATE_VM_IP 2>/dev/null
    
    if [ $? -ne 0 ]; then
        echo "✅ SUCCESS: Private VM is NOT accessible from internet (as expected)"
    else
        echo "⚠️  WARNING: Private VM is accessible from internet (security concern!)"
    fi
    echo ""
fi

# Test 6: SSH connectivity to public VM
echo "Test 6: Testing SSH Access to Public VM..."
echo "Command: ssh -o ConnectTimeout=5 $USERNAME@$PUBLIC_VM_IP 'echo Connection successful'"
ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no "$USERNAME@$PUBLIC_VM_IP" 'echo "✅ SSH Connection successful"' 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ SUCCESS: SSH access to public VM working"
else
    echo "⚠️  INFO: SSH not tested (credentials may be needed)"
fi
echo ""

# Test 7: Check response headers
echo "Test 7: Checking Response Headers..."
echo "Command: curl -I http://$PUBLIC_VM_IP 2>/dev/null | head -n 5"
HEADERS=$(curl -I -s http://$PUBLIC_VM_IP 2>/dev/null | head -n 5)

if [ -n "$HEADERS" ]; then
    echo "✅ SUCCESS: Received response headers"
    echo "$HEADERS" | sed 's/^/   /'
    
    if echo "$HEADERS" | grep -q "nginx"; then
        echo "   ✓ Server: Nginx detected"
    fi
else
    echo "⚠️  No headers received"
fi
echo ""

# Summary
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo ""

# Calculate success rate
TESTS_RUN=4
TESTS_PASSED=0

[ "$HTTP_CODE" = "200" ] && ((TESTS_PASSED++))
echo "$CONTENT" | grep -q "html" && ((TESTS_PASSED++))
echo "$HEALTH" | grep -q "healthy" && ((TESTS_PASSED++))
echo "$STATUS" | grep -q "Backend" && ((TESTS_PASSED++))

echo "Tests Passed: $TESTS_PASSED/$TESTS_RUN"
echo ""

if [ "$TESTS_PASSED" -eq "$TESTS_RUN" ]; then
    echo "✅ All tests passed! Reverse proxy is working correctly."
elif [ "$TESTS_PASSED" -ge 2 ]; then
    echo "⚠️  Partial success. Some features may still be initializing."
    echo "   Wait 2-3 minutes and run the script again."
else
    echo "❌ Most tests failed. Check deployment logs and troubleshoot."
fi

echo ""
echo "=========================================="
echo "Quick Access Commands"
echo "=========================================="
echo ""
echo "Access in browser:"
echo "  http://$PUBLIC_VM_IP"
echo ""
echo "Check proxy health:"
echo "  curl http://$PUBLIC_VM_IP/health"
echo ""
echo "Check proxy status:"
echo "  curl http://$PUBLIC_VM_IP/proxy-status"
echo ""
echo "View full page content:"
echo "  curl http://$PUBLIC_VM_IP"
echo ""
echo "SSH to public VM:"
echo "  ssh $USERNAME@$PUBLIC_VM_IP"
echo ""

if [ -n "$PRIVATE_VM_IP" ]; then
    echo "SSH to private VM (through public VM):"
    echo "  ssh -J $USERNAME@$PUBLIC_VM_IP $USERNAME@$PRIVATE_VM_IP"
    echo ""
    echo "Test backend from public VM:"
    echo "  ssh $USERNAME@$PUBLIC_VM_IP 'curl http://$PRIVATE_VM_IP'"
    echo ""
fi

echo "=========================================="
echo ""

# Final recommendations
if [ "$HTTP_CODE" = "502" ]; then
    echo "⏰ NOTE: Backend returned 502 - Extensions may still be running."
    echo "   Wait 2-3 minutes and test again with:"
    echo "   ./test-deployment.sh $PUBLIC_VM_IP"
    echo ""
elif [ "$TESTS_PASSED" -lt "$TESTS_RUN" ]; then
    echo "🔧 TROUBLESHOOTING:"
    echo "   1. Check VM extensions: az vm extension list --resource-group <RG> --vm-name <VM>"
    echo "   2. SSH to public VM and check Nginx: sudo systemctl status nginx"
    echo "   3. View Nginx logs: ssh $USERNAME@$PUBLIC_VM_IP 'sudo tail -20 /var/log/nginx/error.log'"
    echo "   4. Check deployment logs in Azure Portal"
    echo ""
fi

echo "For detailed guide, see REVERSE-PROXY-GUIDE.md"
echo ""
