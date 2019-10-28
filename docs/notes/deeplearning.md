# Deep learning as probabilistic graphical models

* Nodes:
    * Output is the top node.
    * Input is the bottom node.
    * Hidden nodes numeration counts down from top to bottom, where nodes at higher levels represent more abstract concept than node at lower levels.
* Arrows:
    * A model can be directed (deep directed networks), undirected (deep Boltzmann machines), or partially directed and partially undirected (deep belief network). See Figure 28.1 in Murphy (2012).
    * A model may allow intralayers connections between hidden units (general) or not (restricted). The former are impractical to learn.
    * Each node at the bottom and the intermediates layers has arrows pointing to every node at the immediately higher layer (i.e. no jumps).
* Layers:
    * Layers are vector valued:
        * the dimensionality of the hidden layers determines the width of the model.
        * Rather than thinking of the layer as a single vector-to-vector function, we can also think of it as consisting of many units acting in parallel, each representing a vector-to-scalar function (a neuron).
        * An activation function is used to compute the hidden layer values (e.g. linear, sigmoidal, softmax, ReLus, etc).
* Network architecture (AKA model design):
    * How many layers should the network contain?
    * How should the layers be connected to each other?
    * How many units should be in each layer?
* Example: computed vision model analyzing an image. See [Figure 1.2](http://www.deeplearningbook.org/contents/intro.html) in Goodfellow et al (2016).
    * Top layer: output (car, person, animal).
    * 3rd hidden layer: object parts.
    * 2nd hidden layer: corner and contours.
    * 1st hidden layer: edges.
    * Bottom layer: input pixels, the visible/observable layer.
* Other:
    * The diagram is conceived bottom-up. From the visible node (e.g. pixels), it's easier to first learn more concrete features (e.g. edges). From these concrete features, we find more abstract features (e.g. corners and contours). From abstract features, we find more abstract features (e.g. object parts). Abstraction is built from the bottom up.
    * Flowchart of a deep-learning algorithm: Input -> Simple features -> Additional layers of more abstract features -> Mapping from features -> Output.

# References

* Goodfellow, I., Bengio, Y., & Courville, A. (2016). Deep learning. MIT press. [Available online](http://www.deeplearningbook.org/).
* Murphy, K. P. (2012). Machine learning: a probabilistic perspective. MIT press.
