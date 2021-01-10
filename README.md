# GML_Glauber_Dynamics.jl


``GML_Glauber_Dynamics`` is a julia package for learning graphical models from time correlated sampled generated through Gibbs sampling (aka Glauber dynamics). It is built on top of the julia package ``GraphicalModelLearning.jl`` ([see package here](https://github.com/lanl-ansi/GraphicalModelLearning.jl)).

## Installation

Install with Pkg, just like any other registered Julia package:

```jl
pkg> add GML_Glauber_Dynamics  # Press ']' to enter the Pkg REPL mode.
```

## Getting started

Let's start with a simple example where we generate samples through Glauber dynamics from an Ising model defined on a three node graph. The goal is to then check if the learned graph is close to the true graph from which the samples were generated.

```
using GraphicalModelLearning

model = FactorGraph([0.0 0.9 0.1; 0.9 0.0 0.1; 0.1 0.1 0.0])
n_samples = 100000
samples_T, samples_mixed_T = gibbs_sampling(model, n_samples, T_regime())
learned_gm = learn_glauber_dynamics(samples_T)

err = abs.(convert(Array{Float64,2}, model) - learned_gm)
```

## Reference

Watch this space! Link to preprint on arxiv coming soon!

## License

Copyright (c) 2020 Arkopal Dutt. Released under the MIT License. See [`LICENSE`](https://github.com/arkopaldutt/GML_Glauber_Dynamics.jl/blob/main/LICENSE) for details.
