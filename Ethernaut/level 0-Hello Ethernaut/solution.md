#   Level 0 Hello Ethernaut
實力地址：`0x46F44771b2481866a170a70Ea2f206739988E43F`

## 題目說明
來看看這個關卡合約的 info 方法

contract.info()
如果你使用的是 Chrome v62，可以使用 await contract.info()
你應該已經在合約裡面找到所有你破關所需的資料和工具了。當你覺得你已經完成了這關，按一下這個頁面的橘色按鈕就可以提交合約。這會將你的實例發送回給 ethernaut， 然後就可以用來判斷你是否完成了任務。

## POC
1. 呼叫合約 `info()`
    ```bash
    cast call 0x46F44771b2481866a170a70Ea2f206739988E43F "info()"
    ```
    回傳結果
    ```bash!
    0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000027596f752077696c6c2066696e64207768617420796f75206e65656420696e20696e666f3128292e00000000000000000000000000000000000000000000000000
    ```
    使用 to-ascii 
    ```bash!
    cast to-ascii 0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000027596f752077696c6c2066696e64207768617420796f75206e65656420696e20696e666f3128292e00000000000000000000000000000000000000000000000000
    ```
    回傳結果
    ```
    You will find what you need in info1()
    ```
2.  呼叫合約 `info1()`
    ```bash!
    cast call 0x46F44771b2481866a170a70Ea2f206739988E43F "info1()"
    // to-ascii: Try info2(), but with "hello" as a parameter.
    ```
3.  呼叫合約 `info2(string)` 攜帶值 hello
    ```bash!
    cast call 0x46F44771b2481866a170a70Ea2f206739988E43F "info2(string)" "hello"
    // to-ascii: The property infoNum holds the number of the next info method to call.
    ```
4. 呼叫合約 `infoNum()`
    ```bash!
    cast call 0x46F44771b2481866a170a70Ea2f206739988E43F "infoNum()"
    // to-dec: 42
    ```
5.  呼叫合約 `info42()`
    ```bash!
    cast call 0x46F44771b2481866a170a70Ea2f206739988E43F "info42()"
    // to-ascii: theMethodName is the name of the next method.
    ```
6.  呼叫合約 `theMethodName()`
    ```
    cast call 0x46F44771b2481866a170a70Ea2f206739988E43F "theMethodName()"
    // to-ascii: The method name is method7123949.
    ```

7. 呼叫合約 `method7123949()`
    ```
    cast call 0x46F44771b2481866a170a70Ea2f206739988E43F "method7123949()"
    // to-ascii: If you know the password, submit it to authenticate().
    ```
8.  呼叫合約 `password()`
    ```
    cast call 0x46F44771b2481866a170a70Ea2f206739988E43F "password()"
    // to-ascii: ethernaut0
    ```
9.  呼叫合約 'authenticate(string)' 攜帶 ethernaut0
    ```
    cast send --private-key=<YOUR_PRIVATE_KEY>  0x46F44771b2481866a170a70Ea2f206739988E43F "authenticate(string)" "ethernaut0"
    ```
    發送交易結果
    ```
    blockHash               0x9bbcc58b7fb5068c4602ad9cb95b378b6ef8cf74e6c0a55fd28b72b4a8c03d97
    blockNumber             3404392
    contractAddress         
    cumulativeGasUsed       7162564
    effectiveGasPrice       2547570
    from                                        0xEBA2Ef27A1B85a4685953E82848e9d2E9ED5b0B6
    gasUsed                 47095
    logs                    []
    logsBloom                   0x000000000000000000000000000000000000000000000000000000000000  00000000000000000000000000000000000000000000000000000000000000    00000000000000000000000000000000000000000000000000000000000000  00000000000000000000000000000000000000000000000000000000000000    00000000000000000000000000000000000000000000000000000000000000  00000000000000000000000000000000000000000000000000000000000000    00000000000000000000000000000000000000000000000000000000000000  00000000000000000000000000000000000000000000000000000000000000    000000000000000000
    root                    
    status                  1 (success)
    transactionHash             0x429e4d669f398a0c06088665d95c0aff9f8b296d17ce7e9c2b60c6779454  dafb
    transactionIndex        12
    type                    2
    blobGasPrice            
    blobGasUsed             
    authorizationList       
    to                          0x46F44771b2481866a170a70Ea2f206739988E43F
    ```
