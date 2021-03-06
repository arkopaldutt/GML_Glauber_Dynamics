# Script to run a test case for understanding how M scales with β #

# Add paths
loc_gm_package = "../src/"
if !(loc_gm_package in LOAD_PATH)
    push!(LOAD_PATH, "../src/")
end

# Required packages
using LinearAlgebra

using GraphicalModelLearning
using LightGraphs

# Function definitions
using Printf, SparseArrays
include("beta_scaling.jl")

using DelimitedFiles

# parameters
FLAG_create_struct_gm = true
FLAG_regular_random_gm = false
FLAG_lattice_gm = true
FLAG_weak_impurity = false
sampling_regime = M_regime()
learning_algo = NLP()

if FLAG_lattice_gm
    # text file to save adjacency matrix in
    file_adj_matrix_gm = "adj_matrix_ferro_lattice_gm_A_M.txt"
    # name of picture to save graphical model in
    file_plot_gm = "ferro_lattice_gm_A_M.eps"
    # File to save final results
    file_M_opt_gm = "M_opt_Ferro_Lattice_A_M_tol.txt"
elseif FLAG_regular_random_gm
    # text file to save adjacency matrix in
    file_adj_matrix_gm = "adj_matrix_spin_glass_gm.txt"
    # name of picture to save graphical model in
    file_plot_gm = "spin_glass_gm3.eps"
    # File to save final results
    file_M_opt_gm = "M_opt_M_Regime_Regular_Random_B.txt"
end

# Simple test
N = 16
d = 4
α = 0.4
#β_array = [0.8+0.2*i for i=1:11]
β_array = [1.1,1.5,1.9,2.3]

# Create and plot the initial graphical graphical model
β = copy(β_array[4])
adj_matrix, struct_adj_matrix = ferro_lattice(N,α,β,FLAG_weak_impurity)
m = n = Int(sqrt(N))
open(file_adj_matrix_gm, "w") do io
    writedlm(io, adj_matrix)
end;

## Start the complexity studies
τ = α/2
L = 45
M_factor = 0.05

M_opt = Array{Int64,1}(undef,length(β_array))

let
    M_guess = 9000
    for i = 1:length(β_array)
        # define β
        β = copy(β_array[i])
        println(β)
        println(M_guess)

        # Create the adjacency matrix
        adj_matrix, struct_adj_matrix = ferro_lattice(N,α,β,FLAG_weak_impurity)

        # Get the optimum number of samples
        M_opt[i] = get_M_opt_glauber_dynamics(adj_matrix, RPLE(), learning_algo, sampling_regime, τ, L, M_guess, M_factor)

        # Update the guess of M_opt
        @printf("beta=%f, M_opt=%d \n", β, M_opt[i])
        M_guess = Int(floor(0.8*copy(M_opt[i])))
    end
end

writedlm(file_M_opt_gm,M_opt)
