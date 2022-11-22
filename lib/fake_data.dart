library fake_data;

import 'model/accommodationModel.dart';
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