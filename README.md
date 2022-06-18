# ClassBlueprint
The idea behind the original Class Blueprint visualization is to present the internal structure of classes in terms of fields, their accesses, and the method call-flow. Additional semantic information was represented using colors. 

The Class Blueprint V2 also supports dead code identification, methods under tests and calling relationships between class and instance level methods. In addition, the Class Blueprint V2 enhances the understanding of fields by showing how fields of super-/subclasses are accessed, and stresses the extension category of a method (monomorphic, polymorphic or megamorphic) to convey how a given method fits into its wider context.

# Setting up the visualization:
1. Create a new Moose.9 image,

2. Load the latest version of Roassal,
<img width="823" alt="image" src="https://user-images.githubusercontent.com/34944559/174438454-0a91006e-ebb9-4ada-8960-15a507e0b920.png">

3. Load the visualization using the script:
``` Smalltalk
Metacello new
  baseline: 'ClassBlueprint';
  repository: 'github://NourDjihan/ClassBlueprint/src';
  load.
 ```

# Creating the Moose Model of your project:

1. <img width="631" alt="image" src="https://user-images.githubusercontent.com/34944559/174438596-507e8efd-b930-4beb-b7d4-75b087e1a17f.png">
2. <img width="728" alt="image" src="https://user-images.githubusercontent.com/34944559/174438618-f1cbac39-e442-4d68-bbb4-b09f96020513.png">
3. <img width="389" alt="image" src="https://user-images.githubusercontent.com/34944559/174438621-1ddca995-3267-4d27-bff6-8919470feefe.png">
4. <img width="725" alt="image" src="https://user-images.githubusercontent.com/34944559/174438623-08e54bc3-587d-49b4-aefa-8d593ad5d493.png">



A full presentation on how to use the visualization can be found here:


