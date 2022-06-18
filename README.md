# ClassBlueprint
The idea behind the original Class Blueprint visualization is to present the internal structure of classes in terms of fields, their accesses, and the method call-flow. Additional semantic information was represented using colors. 

The Class Blueprint V2 also supports dead code identification, methods under tests and calling relationships between class and instance level methods. In addition, the Class Blueprint V2 enhances the understanding of fields by showing how fields of super-/subclasses are accessed, and stresses the extension category of a method (monomorphic, polymorphic or megamorphic) to convey how a given method fits into its wider context. ![Screenshot 2022-06-18 at 14 33 17](https://user-images.githubusercontent.com/34944559/174437843-82b3428e-0599-4c23-8a5c-eeec6b71d71c.png)

# To load the visualization:
First create a new moose image, then copy this code into the playground
``` Smalltalk
Metacello new
  baseline: 'ClassBlueprint';
  repository: 'github://NourDjihan/ClassBlueprint/src';
  load.
 ```
