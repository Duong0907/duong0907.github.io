---
layout: post
title: Talk about HTTPS - Part 1
slug: talk-about-https-1
---

## 1.	Giới thiệu
Có lẽ chúng ta ai cũng đều biết về 2 giao thức mạng là http và https. Về cơ bản thì http sẽ truyền dữ liệu đi qua internet mà không thông qua mã hóa, điều này sẽ gây ra nguy cơ bị đánh cắp dữ liệu rất cao. 

Trong khi đó, https thường được biết là = http + secure, dữ liệu sẽ được mã hóa ở bên gửi và giải mã khi đến bên nhận, sẽ an toàn hơn rất nhiều, do đó các trang web hiện nay đều đã chuyển sang sử dụng https (chẳng hạn như trang của [Bếp UIT](https://bepuit.com)). Vậy cụ thể thì quá trình mã hóa này hoạt động như thế nào, chúng ta hãy cùng tìm hiểu thông qua bài viết hôm nay nhé.

## 2.	Mã hóa đối xứng và bất đối xứng

Đầu tiên hãy nói về một vấn đề cơ bản: Nếu chúng ta gửi dữ liệu từ nơi này đến nơi khác bằng plain text thì chuyện gì sẽ xảy ra? 

Đó là rất có khả năng, một kẻ xấu đứng giữa có thể bắt được và đọc thông tin của chúng ta. Vì vậy chúng ta cần phải mã hóa dữ liệu trước khi truyền đi, và người nhận sẽ giải mã để đọc được dữ liệu đó.

![Mã hóa đối xứng](https://images.viblo.asia/129530ff-92eb-4c49-92cf-a484bb43aeae.png)


*Trong mã hóa đối xứng*, người gửi sẽ mã hóa thông tin với một secret key, và người nhận sẽ giải mã với cùng một secret key đó. Nhưng có một vấn đề cần giải quyết khi sử dụng loại mã hóa này: Làm sao để 2 người trao đổi khóa bí mật (thông qua internet) mà không bị lộ khóa này.

Vấn đề sẽ được giải quyết nếu chúng ta sử dụng “Mã hóa bất đối xứng” – nơi mà không cần trao đổi khóa bí mật nữa.

![Mã hóa bất đối xứng](https://images.viblo.asia/e3bdf658-61ea-43b5-851c-72b2e88ae3bc.png)

*Trong mã hóa bất đối xứng*, mỗi người sẽ có một cặp public key và private key với tính chất: **dữ liệu được mã hóa bằng public key, chỉ có thể được giải mã bởi private key tương ứng**. Public key của một người có thể được thoải mái gửi đi ra bên ngoài, trong khi private key sẽ được tuyệt đối giữ bí mật, không tiết lộ cho bất kì ai khác (có thể lưu local trong máy của người đó).

Như hình minh họa ở trên, chúng ta có thể thấy, người gửi biết được public key của người nhận, sau đó mã hóa dữ liệu muốn gửi đi bằng public key này. Sau khi dữ liệu đến nơi, người nhận sẽ dùng private key của mình để giải mã và đọc được dữ liệu bên trong.

Trong trường hợp có một kẻ thứ 3 bắt được đoạn dữ liệu được mã hóa này, hắn cũng không thể giải mã được, vì dữ liệu đã được mã hóa bằng public key của người gửi, nên chỉ có thể giải mã ra bằng private key của người đó mà thôi, mà private key này hoàn toàn không được chia sẻ với ai.

Chúng ta có thể để ý thấy rằng không hề có một sự trao đổi khóa bí mật diễn ra ở đây. Private key của người nhận sẽ được bảo mật tuyệt đối và đó là điều mà mã hóa đối xứng không làm được.

## 3.	Làm sao tạo ra một kết nối an toàn

Nguyên tắc cơ bản để tạo ra một kết nối an toàn là thực hiện truyền nhận dữ liệu thông qua mã hóa đối xứng bằng một session key (mã hóa đối xứng), và 2 bên sẽ trao đối session key này thông qua mã hóa bất đối xứng. Cụ thể là như sau:

![Kết nối an toàn sử dụng cả mã hóa đối xứng và bất đối xứng](https://images.viblo.asia/b4bf328c-60cf-412b-8de1-137e632a040d.png)

Ví dụ đây là một kết nối giữa máy mình và Netflix.

Đầu tiên thì máy chủ của Netflix sẽ được cấp cho một cặp public và private key. Trình duyệt của mình sẽ gửi yêu cầu và Netflix sẽ truyền public key này cho mình.

Sau đó, trình duyệt của mình sẽ tạo ra một session key (khóa màu vàng, đóng vai trò là secret key trong mã hóa đối xứng). Session key được gửi tới máy chủ của Netflix thông qua mã hóa đối xứng, vì ta đã biết được public key của Netflix. Session key đã được truyền từ trình duyệt của mình đến máy chủ Netflix một cách an toàn.

Sau các bước này thì 2 bên có thể thoải mái truyền dữ liệu đi bằng việc mã hóa đối xứng với session key đã biết. 

Nhưng, đây chưa phải là cách tối ưu nhất. Có một vấn đề khác lại nảy sinh.

![Lỗ hổng trong kết nối an toàn](https://images.viblo.asia/ed1741a0-fd98-47e3-9f45-a9d90591de1e.png)

Mọi chuyện sẽ diễn ra êm đẹp nếu như ở bước đầu tiên, kẻ tấn công, bằng một cách thần kì nào đấy, bắt được thông điệp yêu cầu gửi public key của mình đến Netflix, và gửi cho mình một public key giả (public key của hắn).

Và sau đó, session key sẽ được mã hóa bằng public key giả, và tên giả mạo này chỉ việc giải mã bằng private key của hắn và đọc được session key của mình.

Và kể từ đó, dữ liệu truyền đi được mã hóa bằng session key của mình đều bị kẻ gian ác này đọc được. 

Điều này quá nguy hiểm đúng không nào, đó là lý do cho sự ra đời của certificate. Chúng ta sẽ tìm hiểu chúng trong các bài viết tiếp theo nhé.
