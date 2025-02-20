---
layout: post
title: Talk about HTTPS - Part 2
slug: talk-about-https-2
---


Đây là phần 2 của chuỗi bài viết về giao thức https và cách hoạt động của certificate của mình. Nếu các bạn chưa đọc phần 1 thì đọc [tại đây](/talk-about-https-1.html) nhé.

## 4. Chứng chỉ (Certificate) là gì?

![](https://images.viblo.asia/a9b53c53-9a7d-47c4-969b-35c9d1bee58b.png)


Trong bài trước, có một vấn đề được đặt ra là, làm sao để đảm bảo được public key mà mình nhận được chính xác là public key của Netflix, mà không phải là của một kẻ thứ 3 nào khác. Câu trả lời là Netflix sẽ không đơn thuần gửi cho mình public key của họ, mà là gửi một chứng chỉ.

Trong chứng chỉ này có chứa các thành phần sau:

* Subject: tên miền mà chúng ta cần có public key. Ở đây là netflix.com.
* Subject Public Key: public key mà chúng ta đang cần.
* Issuer Name: bên phát hành của certificate này. Như trên hình là Amazon Root CA.
* Issuer Signature: chữ kí số của bên phát hành cho certificate, để đảm bảo nội dung của certificate không bị thay đổi hay làm giả.


Có chứng chỉ này, chúng ta có thể biết tên Subject Public Key có đúng là của Subject hay không, nếu chúng ta xác nhận được nội dung của chứng chỉ không bị làm giả.

Để làm được điều này, chúng ta dùng kĩ thuật verify chữ kí số trong chứng chỉ. Cụ thể thì verify hoạt động như thế nào?


## 5. Chữ kí số (Digital Signature)

![](https://images.viblo.asia/b243b340-df24-44cc-8ebb-102fb87488ee.png)

Chữ kí số có 2 lợi ích:

* Có thể xác minh được rằng dữ liệu được kí có bị thay thế hay làm giả không.
* Không cần che giấu dữ liệu.

Trước khi được kí bằng chữ kí số, bên kí bắt buộc phải có một cặp public và private key.

Trong chữ kí số ta có 2 hành động chính là: kí (sign) và xác nhận (verify).

* Chữ kí được tạo ra bằng cách: dữ liệu đi qua hàm băm (hash function), ta có dữ liệu đã được băm, sau đó mã hóa tiếp bằng private key, ta có chữ kí số của dữ liệu này. Trên hình là 8cf24dba3.
* Chữ kí được xác nhận bằng cách: băm lại dữ liệu bằng hàm băm (hash function) ta được mã băm của dữ liệu, giải mã chữ kí số ta được một mã băm nữa. Nếu 2 mã băm này giống nhau thì chứng tỏ dữ liệu chưa bị thay đổi kể từ khi được kí.

## 6. Chứng chỉ được tạo ra và hoạt động như thế nào?

![](https://images.viblo.asia/2af41054-3b4a-4742-a006-a4b3fb522df0.png)


Khi Netflix muốn được cấp một chứng chỉ cho tên miền của họ, Netflix sẽ yêu cầu cấp chứng chỉ từ một CA (nhà cung cấp chứng chỉ), chẳng hạn như Amazon, thông qua AWS Certificate Manager. CA này sẽ dùng private key của mình để kí cho chứng chỉ của Netflix sau khi Netflix chứng minh được public key của họ.

![](https://images.viblo.asia/5d35c372-a4ce-4367-b7cd-4172c0964ba8.png)


Khi nhận được certificate từ Netflix, điều chúng ta cần làm là xác nhận rằng chứng chỉ này có hợp lệ hay không, để có thể tin tưởng được certificate này chứa đúng public key của netflix.com.

Để xác nhận chứng chỉ, ta cần biết được public key của Issuer, bên đã kí chứng chỉ. Như trong hình thì Issuer ở đây là Amazon Root CA, Issuer gốc của Amazon. Trong máy của chúng ta sẽ tồn tại một chứng chỉ gốc của Issuer này, trong đó chứa public key của Amazone Root CA, và được kí bởi chính Amazone Root CA.

Có được public key của Issuer rồi thì ta chỉ việc verify lại chứng chỉ để xác nhận rằng nó có hợp lệ không.

## 7. Chain of trust

![](https://images.viblo.asia/85e8efec-2a66-4ffe-9395-1a87b8360a78.png)

Trên thực tế, các chứng chỉ thường sẽ không được cấp bởi CA gốc như Amazon Root CA, mà nó sẽ thông qua một vài CA trung gian. Chứng chỉ của các CA sẽ được kí liên tiếp tạo thành một chuỗi các chứng chỉ reference nhau:

![](https://images.viblo.asia/7efc4694-6e8f-474c-8419-99ad61b20227.png)

## Kết luận

Như vậy, trên đây là tất cả quy trình căn bản của việc tạo ra một kết nối an toàn trong giao thức https, từ cách hoạt động của mã hóa bất đối xứng đến chứng chỉ và chữ kí số. Nếu thấy bài viết của mình hay và hữu ích, các bạn hãy cho mình 1 upvote nhé. Hay có thắc mắc gì thì để lại comment nè. 

## Reference

[Beta to Prod: How certificates actully works](https://www.youtube.com/watch?v=4wgl-PoDrJ4&t=298s)