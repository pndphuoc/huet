library fake_data;

import 'model/accommodationModel.dart';
import 'model/attraction/tourist_attraction.dart';
import 'model/locationModel.dart';
import 'model/roomTypeModel.dart';

List<roomTypeModel> roomTypesOfHuongGiangHotel = [
  roomTypeModel(id: 1, name: "Single room"),
  roomTypeModel(id: 2, name: "Double room"),
  roomTypeModel(id: 3, name: "Triple room"),
  roomTypeModel(id: 4, name: "VIP room")
];
List<String> imagesOfHuongGiangHotel = [
  'https://ak-d.tripcdn.com/images/200h0i0000009ehpzF02A_Z_1100_824_R5_Q70_D.jpg',
  'https://www.huonggianghotel.com.vn/wp-content/uploads/2018/06/DSC_4563-HDR2_1600x1068-1.jpg',
  'https://cf.bstatic.com/xdata/images/hotel/max1280x900/185016305.jpg?k=e0510db64b6c0f4b0623cb63a4014b95c677970d880c414c864fbbe094a9211c&o=&hp=1'
];

List<hotelModel> listHotels = [
  hotelModel(
      id: 1,
      accommondationType: 1,
      name: "Silk Path Grand Hue Hotel",
      address: "2 Lê Lợi",
      accommodationLocation:
      location(latitude: 16.458015573692116, longitude: 107.57969752805363),
      images: ["https://pix10.agoda.net/hotelImages/14694836/-1/9914bb8998c5b239d3c8ac6b8563016d.jpg?ca=13&ce=1&s=1024x768", "http://silkpathhotel.com/media/ckfinder/images/Hotel/2/Hue6789/Hue_Acco_doc.jpg", "http://silkpathhotel.com/media/ckfinder/images/Slide_mice/Hue_Mice_Banquet.jpg", "https://cdn1.ivivu.com/iVivu/2020/09/10/11/spgh-overview-2-cr-800x450.jpg"],
      price: 200,
      types: roomTypesOfHuongGiangHotel,
      rating: 5),
  hotelModel(
      id: 1,
      accommondationType: 2,
      name: "Hương Giang",
      address: "69 Lê Lợi",
      accommodationLocation:
      location(latitude: 16.470970686019427, longitude: 107.5944807077246),
      images: imagesOfHuongGiangHotel,
      price: 200,
      types: roomTypesOfHuongGiangHotel,
      rating: 4),
  hotelModel(
      id: 2,
      accommondationType: 1,
      name: "Vinpearl Hue",
      address: "50A Hùng Vương",
      accommodationLocation:
      location(latitude: 16.463430881885497, longitude: 107.59451227529739),
      images: ["https://statics.vinpearl.com/Hinh-anh-review-vinpearl-Hu%E1%BA%BF.jpg", "https://cdn1.ivivu.com/iVivu/2019/04/12/11/khach-san-vinpearl-hue-17-800x450.jpg", "https://statics.vinpearl.com/gia-phong-vinpearl-hue-2_1627379379.jpg"],
      price: 200,
      types: roomTypesOfHuongGiangHotel,
      rating: 4.5),
  hotelModel(
      id: 3,
      accommondationType: 1,
      name: "Imperial Hotel Hue",
      address: "08 Hùng Vương",
      accommodationLocation:
      location(latitude: 16.463786394219735, longitude: 107.60703420242594),
      images: ["https://yt3.ggpht.com/ytc/AMLnZu_J1rEF4cTT9WCVqdya_lp1zujGum-jdPtWrUur=s900-c-k-c0x00ffffff-no-rj", "https://etrip4utravel.s3-ap-southeast-1.amazonaws.com/images/product/2022/03/2ee0927c-e8b1-4a65-86d5-35944611703e.jpg", "https://khamphadisan.com.vn/wp-content/uploads/2016/10/home_imperial.jpg"],
      price: 200,
      types: roomTypesOfHuongGiangHotel,
      rating: 4.5),
  hotelModel(
      id: 1,
      accommondationType: 3,
      name: "Azerai La Residence, Hue",
      address: "5 Lê Lợi",
      accommodationLocation:
      location(latitude: 16.459255735696967, longitude: 107.5802938520555),
      images: ["https://d19lgisewk9l6l.cloudfront.net/assetbank/Exterior_La_Residence_Hotel_Spa_28562.jpg", "https://www.vendomtalents.com/image/news/news-main-azerai-la-residence-opens-in-hue-vietnam.1550593386.jpg", "https://savingbooking.com/wp-content/uploads/2021/01/175012720.jpg"],
      price: 200,
      types: roomTypesOfHuongGiangHotel,
      rating: 4),
];

List<TouristAttaction> listAttraction = [
  TouristAttaction(id: 1, title: "Đại Nội Huế", address: "Đường 23/8, phường Thuận Hòa, Thành phố Huế, tỉnh Thừa Thiên Huế", description: "Đại Nội Huế là một phần trong quần thêt di tích Cố đô Huế, mang đậm dấu ấn văn hóa, lịch sử, kiến trúc của triều đại nhà Nguyễn, tổ chức UNESCO đã công nhận là di sản văn hóa thế giới năm 1993. "
      "Đại Nội Huế chính là nơi sinh hoạt và diễn ra các hoạt động của vua chúa Nguyễn cùng triều đình phong kiến cuối cùng của nước ta. Đại Nội Huế có thể xem là một công trình có quy mô đồ sộ nhất trong lịch sử Việt Nam từ trước đến nay. "
      "Đại Nội Huế có quá trình xây dựng kéo dài trong nhiều năm với hàng vạn người thi công cùng hàng loạt các công việc như lấp sông, đào hào, đắp thành, bên cạnh đó là khối lượng đất đá khổng lồ lên đến hàng triệu mét khối",
      htmldescription: "<p>Đại Nội Huế l&agrave; một phần trong quần th&ecirc;t di t&iacute;ch Cố đ&ocirc; Huế, mang đậm dấu ấn văn h&oacute;a, lịch sử, kiến tr&uacute;c của triều đại nh&agrave; Nguyễn, tổ chức UNESCO đ&atilde; c&ocirc;ng nhận l&agrave; di sản văn h&oacute;a thế giới năm 1993. Đại Nội Huế ch&iacute;nh l&agrave; nơi sinh hoạt v&agrave; diễn ra c&aacute;c hoạt động của vua ch&uacute;a Nguyễn c&ugrave;ng triều đ&igrave;nh phong kiến cuối c&ugrave;ng của nước ta. Đại Nội Huế c&oacute; thể xem l&agrave; một c&ocirc;ng tr&igrave;nh c&oacute; quy m&ocirc; đồ sộ nhất trong lịch sử Việt Nam từ trước đến nay. Đại Nội Huế c&oacute; qu&aacute; tr&igrave;nh x&acirc;y dựng k&eacute;o d&agrave;i trong nhiều năm với h&agrave;ng vạn người thi c&ocirc;ng c&ugrave;ng h&agrave;ng loạt c&aacute;c c&ocirc;ng việc như lấp s&ocirc;ng, đ&agrave;o h&agrave;o, đắp th&agrave;nh, b&ecirc;n cạnh đ&oacute; l&agrave; khối lượng đất đ&aacute; khổng lồ l&ecirc;n đến h&agrave;ng triệu m&eacute;t khối.</p>\n",
      image: "https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/03/Cong-Ngo-Mon-e1502361090463.png", images: "https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/03/Cong-Ngo-Mon-e1502361090463.png", latitude: 16.4675821, longitude: 107.5792951),
  TouristAttaction(id: 1, title: "Đại Nội Huế", address: "Đường 23/8, phường Thuận Hòa, Thành phố Huế, tỉnh Thừa Thiên Huế", description: "Đại Nội Huế là một phần trong quần thêt di tích Cố đô Huế, mang đậm dấu ấn văn hóa, lịch sử, kiến trúc của triều đại nhà Nguyễn, tổ chức UNESCO đã công nhận là di sản văn hóa thế giới năm 1993. "
      "Đại Nội Huế chính là nơi sinh hoạt và diễn ra các hoạt động của vua chúa Nguyễn cùng triều đình phong kiến cuối cùng của nước ta. Đại Nội Huế có thể xem là một công trình có quy mô đồ sộ nhất trong lịch sử Việt Nam từ trước đến nay. "
      "Đại Nội Huế có quá trình xây dựng kéo dài trong nhiều năm với hàng vạn người thi công cùng hàng loạt các công việc như lấp sông, đào hào, đắp thành, bên cạnh đó là khối lượng đất đá khổng lồ lên đến hàng triệu mét khối",
      htmldescription: "<p>Đại Nội Huế l&agrave; một phần trong quần th&ecirc;t di t&iacute;ch Cố đ&ocirc; Huế, mang đậm dấu ấn văn h&oacute;a, lịch sử, kiến tr&uacute;c của triều đại nh&agrave; Nguyễn, tổ chức UNESCO đ&atilde; c&ocirc;ng nhận l&agrave; di sản văn h&oacute;a thế giới năm 1993. Đại Nội Huế ch&iacute;nh l&agrave; nơi sinh hoạt v&agrave; diễn ra c&aacute;c hoạt động của vua ch&uacute;a Nguyễn c&ugrave;ng triều đ&igrave;nh phong kiến cuối c&ugrave;ng của nước ta. Đại Nội Huế c&oacute; thể xem l&agrave; một c&ocirc;ng tr&igrave;nh c&oacute; quy m&ocirc; đồ sộ nhất trong lịch sử Việt Nam từ trước đến nay. Đại Nội Huế c&oacute; qu&aacute; tr&igrave;nh x&acirc;y dựng k&eacute;o d&agrave;i trong nhiều năm với h&agrave;ng vạn người thi c&ocirc;ng c&ugrave;ng h&agrave;ng loạt c&aacute;c c&ocirc;ng việc như lấp s&ocirc;ng, đ&agrave;o h&agrave;o, đắp th&agrave;nh, b&ecirc;n cạnh đ&oacute; l&agrave; khối lượng đất đ&aacute; khổng lồ l&ecirc;n đến h&agrave;ng triệu m&eacute;t khối.</p>\n",
      image: "https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/03/Cong-Ngo-Mon-e1502361090463.png", images: "https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/03/Cong-Ngo-Mon-e1502361090463.png", latitude: 16.4675821, longitude: 107.5792951),
  TouristAttaction(id: 1, title: "Đại Nội Huế", address: "Đường 23/8, phường Thuận Hòa, Thành phố Huế, tỉnh Thừa Thiên Huế", description: "Đại Nội Huế là một phần trong quần thêt di tích Cố đô Huế, mang đậm dấu ấn văn hóa, lịch sử, kiến trúc của triều đại nhà Nguyễn, tổ chức UNESCO đã công nhận là di sản văn hóa thế giới năm 1993. "
      "Đại Nội Huế chính là nơi sinh hoạt và diễn ra các hoạt động của vua chúa Nguyễn cùng triều đình phong kiến cuối cùng của nước ta. Đại Nội Huế có thể xem là một công trình có quy mô đồ sộ nhất trong lịch sử Việt Nam từ trước đến nay. "
      "Đại Nội Huế có quá trình xây dựng kéo dài trong nhiều năm với hàng vạn người thi công cùng hàng loạt các công việc như lấp sông, đào hào, đắp thành, bên cạnh đó là khối lượng đất đá khổng lồ lên đến hàng triệu mét khối",
      htmldescription: "<p>Đại Nội Huế l&agrave; một phần trong quần th&ecirc;t di t&iacute;ch Cố đ&ocirc; Huế, mang đậm dấu ấn văn h&oacute;a, lịch sử, kiến tr&uacute;c của triều đại nh&agrave; Nguyễn, tổ chức UNESCO đ&atilde; c&ocirc;ng nhận l&agrave; di sản văn h&oacute;a thế giới năm 1993. Đại Nội Huế ch&iacute;nh l&agrave; nơi sinh hoạt v&agrave; diễn ra c&aacute;c hoạt động của vua ch&uacute;a Nguyễn c&ugrave;ng triều đ&igrave;nh phong kiến cuối c&ugrave;ng của nước ta. Đại Nội Huế c&oacute; thể xem l&agrave; một c&ocirc;ng tr&igrave;nh c&oacute; quy m&ocirc; đồ sộ nhất trong lịch sử Việt Nam từ trước đến nay. Đại Nội Huế c&oacute; qu&aacute; tr&igrave;nh x&acirc;y dựng k&eacute;o d&agrave;i trong nhiều năm với h&agrave;ng vạn người thi c&ocirc;ng c&ugrave;ng h&agrave;ng loạt c&aacute;c c&ocirc;ng việc như lấp s&ocirc;ng, đ&agrave;o h&agrave;o, đắp th&agrave;nh, b&ecirc;n cạnh đ&oacute; l&agrave; khối lượng đất đ&aacute; khổng lồ l&ecirc;n đến h&agrave;ng triệu m&eacute;t khối.</p>\n",
      image: "https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/03/Cong-Ngo-Mon-e1502361090463.png", images: "https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/03/Cong-Ngo-Mon-e1502361090463.png", latitude: 16.4675821, longitude: 107.5792951),
  TouristAttaction(id: 1, title: "Đại Nội Huế", address: "Đường 23/8, phường Thuận Hòa, Thành phố Huế, tỉnh Thừa Thiên Huế", description: "Đại Nội Huế là một phần trong quần thêt di tích Cố đô Huế, mang đậm dấu ấn văn hóa, lịch sử, kiến trúc của triều đại nhà Nguyễn, tổ chức UNESCO đã công nhận là di sản văn hóa thế giới năm 1993. "
      "Đại Nội Huế chính là nơi sinh hoạt và diễn ra các hoạt động của vua chúa Nguyễn cùng triều đình phong kiến cuối cùng của nước ta. Đại Nội Huế có thể xem là một công trình có quy mô đồ sộ nhất trong lịch sử Việt Nam từ trước đến nay. "
      "Đại Nội Huế có quá trình xây dựng kéo dài trong nhiều năm với hàng vạn người thi công cùng hàng loạt các công việc như lấp sông, đào hào, đắp thành, bên cạnh đó là khối lượng đất đá khổng lồ lên đến hàng triệu mét khối",
      htmldescription: "<p>Đại Nội Huế l&agrave; một phần trong quần th&ecirc;t di t&iacute;ch Cố đ&ocirc; Huế, mang đậm dấu ấn văn h&oacute;a, lịch sử, kiến tr&uacute;c của triều đại nh&agrave; Nguyễn, tổ chức UNESCO đ&atilde; c&ocirc;ng nhận l&agrave; di sản văn h&oacute;a thế giới năm 1993. Đại Nội Huế ch&iacute;nh l&agrave; nơi sinh hoạt v&agrave; diễn ra c&aacute;c hoạt động của vua ch&uacute;a Nguyễn c&ugrave;ng triều đ&igrave;nh phong kiến cuối c&ugrave;ng của nước ta. Đại Nội Huế c&oacute; thể xem l&agrave; một c&ocirc;ng tr&igrave;nh c&oacute; quy m&ocirc; đồ sộ nhất trong lịch sử Việt Nam từ trước đến nay. Đại Nội Huế c&oacute; qu&aacute; tr&igrave;nh x&acirc;y dựng k&eacute;o d&agrave;i trong nhiều năm với h&agrave;ng vạn người thi c&ocirc;ng c&ugrave;ng h&agrave;ng loạt c&aacute;c c&ocirc;ng việc như lấp s&ocirc;ng, đ&agrave;o h&agrave;o, đắp th&agrave;nh, b&ecirc;n cạnh đ&oacute; l&agrave; khối lượng đất đ&aacute; khổng lồ l&ecirc;n đến h&agrave;ng triệu m&eacute;t khối.</p>\n",
      image: "https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/03/Cong-Ngo-Mon-e1502361090463.png", images: "https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/03/Cong-Ngo-Mon-e1502361090463.png", latitude: 16.4675821, longitude: 107.5792951),
  TouristAttaction(id: 1, title: "Đại Nội Huế", address: "Đường 23/8, phường Thuận Hòa, Thành phố Huế, tỉnh Thừa Thiên Huế", description: "Đại Nội Huế là một phần trong quần thêt di tích Cố đô Huế, mang đậm dấu ấn văn hóa, lịch sử, kiến trúc của triều đại nhà Nguyễn, tổ chức UNESCO đã công nhận là di sản văn hóa thế giới năm 1993. "
      "Đại Nội Huế chính là nơi sinh hoạt và diễn ra các hoạt động của vua chúa Nguyễn cùng triều đình phong kiến cuối cùng của nước ta. Đại Nội Huế có thể xem là một công trình có quy mô đồ sộ nhất trong lịch sử Việt Nam từ trước đến nay. "
      "Đại Nội Huế có quá trình xây dựng kéo dài trong nhiều năm với hàng vạn người thi công cùng hàng loạt các công việc như lấp sông, đào hào, đắp thành, bên cạnh đó là khối lượng đất đá khổng lồ lên đến hàng triệu mét khối",
      htmldescription: "<p>Đại Nội Huế l&agrave; một phần trong quần th&ecirc;t di t&iacute;ch Cố đ&ocirc; Huế, mang đậm dấu ấn văn h&oacute;a, lịch sử, kiến tr&uacute;c của triều đại nh&agrave; Nguyễn, tổ chức UNESCO đ&atilde; c&ocirc;ng nhận l&agrave; di sản văn h&oacute;a thế giới năm 1993. Đại Nội Huế ch&iacute;nh l&agrave; nơi sinh hoạt v&agrave; diễn ra c&aacute;c hoạt động của vua ch&uacute;a Nguyễn c&ugrave;ng triều đ&igrave;nh phong kiến cuối c&ugrave;ng của nước ta. Đại Nội Huế c&oacute; thể xem l&agrave; một c&ocirc;ng tr&igrave;nh c&oacute; quy m&ocirc; đồ sộ nhất trong lịch sử Việt Nam từ trước đến nay. Đại Nội Huế c&oacute; qu&aacute; tr&igrave;nh x&acirc;y dựng k&eacute;o d&agrave;i trong nhiều năm với h&agrave;ng vạn người thi c&ocirc;ng c&ugrave;ng h&agrave;ng loạt c&aacute;c c&ocirc;ng việc như lấp s&ocirc;ng, đ&agrave;o h&agrave;o, đắp th&agrave;nh, b&ecirc;n cạnh đ&oacute; l&agrave; khối lượng đất đ&aacute; khổng lồ l&ecirc;n đến h&agrave;ng triệu m&eacute;t khối.</p>\n",
      image: "https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/03/Cong-Ngo-Mon-e1502361090463.png", images: "https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/03/Cong-Ngo-Mon-e1502361090463.png", latitude: 16.4675821, longitude: 107.5792951),
  TouristAttaction(id: 1, title: "Đại Nội Huế", address: "Đường 23/8, phường Thuận Hòa, Thành phố Huế, tỉnh Thừa Thiên Huế", description: "Đại Nội Huế là một phần trong quần thêt di tích Cố đô Huế, mang đậm dấu ấn văn hóa, lịch sử, kiến trúc của triều đại nhà Nguyễn, tổ chức UNESCO đã công nhận là di sản văn hóa thế giới năm 1993. "
      "Đại Nội Huế chính là nơi sinh hoạt và diễn ra các hoạt động của vua chúa Nguyễn cùng triều đình phong kiến cuối cùng của nước ta. Đại Nội Huế có thể xem là một công trình có quy mô đồ sộ nhất trong lịch sử Việt Nam từ trước đến nay. "
      "Đại Nội Huế có quá trình xây dựng kéo dài trong nhiều năm với hàng vạn người thi công cùng hàng loạt các công việc như lấp sông, đào hào, đắp thành, bên cạnh đó là khối lượng đất đá khổng lồ lên đến hàng triệu mét khối",
      htmldescription: "<p>Đại Nội Huế l&agrave; một phần trong quần th&ecirc;t di t&iacute;ch Cố đ&ocirc; Huế, mang đậm dấu ấn văn h&oacute;a, lịch sử, kiến tr&uacute;c của triều đại nh&agrave; Nguyễn, tổ chức UNESCO đ&atilde; c&ocirc;ng nhận l&agrave; di sản văn h&oacute;a thế giới năm 1993. Đại Nội Huế ch&iacute;nh l&agrave; nơi sinh hoạt v&agrave; diễn ra c&aacute;c hoạt động của vua ch&uacute;a Nguyễn c&ugrave;ng triều đ&igrave;nh phong kiến cuối c&ugrave;ng của nước ta. Đại Nội Huế c&oacute; thể xem l&agrave; một c&ocirc;ng tr&igrave;nh c&oacute; quy m&ocirc; đồ sộ nhất trong lịch sử Việt Nam từ trước đến nay. Đại Nội Huế c&oacute; qu&aacute; tr&igrave;nh x&acirc;y dựng k&eacute;o d&agrave;i trong nhiều năm với h&agrave;ng vạn người thi c&ocirc;ng c&ugrave;ng h&agrave;ng loạt c&aacute;c c&ocirc;ng việc như lấp s&ocirc;ng, đ&agrave;o h&agrave;o, đắp th&agrave;nh, b&ecirc;n cạnh đ&oacute; l&agrave; khối lượng đất đ&aacute; khổng lồ l&ecirc;n đến h&agrave;ng triệu m&eacute;t khối.</p>\n",
      image: "https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/03/Cong-Ngo-Mon-e1502361090463.png", images: "https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/03/Cong-Ngo-Mon-e1502361090463.png", latitude: 16.4675821, longitude: 107.5792951)
];