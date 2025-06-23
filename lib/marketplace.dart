class Product {
  final String imageUrl;
  final String price;
  final String title;
  final String location;
  final String? distance;

  const Product({
    required this.imageUrl,
    required this.price,
    required this.title,
    required this.location,
    this.distance,
  });
}

// Dummy product list
final List<Product> products = [
  Product(
    imageUrl: 'http://localhost/flutter_application_1/php/tampilkan.php?id=21',
    price: 'Rp340.000',
    title: 'Samsung Galaxy A54',
    location: 'Makassar',
    distance: null,
  ),
  Product(
    imageUrl: 'http://localhost/flutter_application_1/php/tampilkan.php?id=13',
    price: 'Rp8.000.000',
    title: '2018 Mazda CX-5 Skyactive Matic',
    location: 'Makassar',
    distance: '51 rb km • Dealer',
  ),
  Product(
    imageUrl: 'http://localhost/flutter_application_1/php/tampilkan.php?id=17',
    price: 'Rp8.000.000',
    title: 'Piano merk Fort',
    location: 'Makassar',
    distance: null,
  ),
  Product(
    imageUrl: 'http://localhost/flutter_application_1/php/tampilkan.php?id=11',
    price: 'Rp2.500.000',
    title: 'iPhone XS 256GB',
    location: 'Makassar',
    distance: null,
  ),
  Product(
    imageUrl: 'http://localhost/flutter_application_1/php/tampilkan.php?id=8',
    price: 'Rp15.000.000',
    title: 'Drone DJI Mavic Pro',
    location: 'Makassar',
    distance: null,
  ),
  Product(
    imageUrl: 'http://localhost/flutter_application_1/php/tampilkan.php?id=12',
    price: 'Rp850.000',
    title: 'Kemeja Premium',
    location: 'Makassar',
    distance: null,
  ),
  Product(
    imageUrl: 'http://localhost/flutter_application_1/php/tampilkan.php?id=14',
    price: 'Rp4.500.000',
    title: 'Mesin Cuci LG 2 Tabung',
    location: 'Makassar',
    distance: null,
  ),
  Product(
    imageUrl: 'http://localhost/flutter_application_1/php/tampilkan.php?id=9',
    price: 'Rp18.500.000',
    title: 'Motor Yamaha Fino',
    location: 'Makassar',
    distance: null,
  ),
];
