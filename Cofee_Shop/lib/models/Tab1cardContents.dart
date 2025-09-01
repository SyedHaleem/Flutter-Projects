class Tab1CardContents
{
  String item;
  String imagepath;
  String specs;
  String description;
  double rating;
  double price;

  Tab1CardContents({required this.item,required this.description,required this.imagepath,required this.price, required this.specs, required this.rating});

}

List<Tab1CardContents> tab1cardcontents =
    [
      Tab1CardContents(item: 'Cappuccino', imagepath: 'assets/images/capatino1.png', specs: 'with Oat Milk', rating: 3.5, price: 3.80, description: "A delicious cappuccino made with oat milk, perfect for a cozy afternoon.",),
      Tab1CardContents(item: 'Cappuccino', imagepath: 'assets/images/capatino2.png', specs: 'with Milk', rating: 3.5, price: 3.80, description: "A delicious cappuccino made with oat milk, perfect for a cozy afternoon.",),
    ];

