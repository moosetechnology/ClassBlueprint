# ClassBlueprint
The idea behind the original Class Blueprint visualization is to present the internal structure of classes in terms of fields, their accesses, and the method call-flow. Additional semantic information was represented using colors. 

The Class Blueprint V2 also supports dead code identification, methods under tests and calling relationships between class and instance level methods. In addition, the Class Blueprint V2 enhances the understanding of fields by showing how fields of super-/subclasses are accessed, and stresses the extension category of a method (monomorphic, polymorphic or megamorphic) to convey how a given method fits into its wider context.

# Setting up the visualization:
1- Create a new Moose.9 image,
2- Load the latest version of Roassal,
<img width="823" alt="image" src="https://user-images.githubusercontent.com/34944559/174438454-0a91006e-ebb9-4ada-8960-15a507e0b920.png">


A full presentation on how to use the visualization can be found here:



# To load the visualization:
First create a new moose image, then copy this code into the playground
``` Smalltalk
Metacello new
  baseline: 'ClassBlueprint';
  repository: 'github://NourDjihan/ClassBlueprint/src';
  load.
 ```
