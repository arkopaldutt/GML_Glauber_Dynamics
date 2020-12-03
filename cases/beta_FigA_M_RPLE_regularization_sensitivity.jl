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
    file_adj_matrix_gm = "adj_matrix_ferro_lattice_gm_A_M_reg_RPLE_sensitivity.txt"
    # name of picture to save graphical model in
    file_plot_gm = "ferro_lattice_gm_A_M.eps"
    # File to save final results
    file_M_opt_gm = "M_opt_FigA_M_RPLE_reg_sensitivity_beta_1_5.txt"
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
β = 1.5

# Create and plot the initial graphical graphical model
adj_matrix, struct_adj_matrix = ferro_lattice(N,α,β,FLAG_weak_impurity)
m = n = Int(sqrt(N))
open(file_adj_matrix_gm, "w") do io
    writedlm(io, adj_matrix)
end;

## Start the complexity studies
τ = α/2
L = 45
M_factor = 0.05
M_guess = 1000

# Different values of regularization coefficient to be tested
c_array = vcat([0.02,0.04],[0.05 + 0.05*i for i=0:9])
#,[0.5 + 0.1*i for i=1:15]
M_opt = Array{Int64,1}(undef,length(c_array))

for i = 1:length(c_array)
    c = copy(c_array[i])
    println(c)
    println(β)
    println(M_guess)

    # Get the optimum number of samples
    M_opt[i] = get_M_opt_glauber_dynamics_regularization(adj_matrix, RPLE(c, true), learning_algo, sampling_regime, τ, L, M_guess, M_factor)

    # Update the guess of M_opt
    @printf("c=%f, beta=%f, M_opt=%d \n", c, β, M_opt[i])
end

writedlm(file_M_opt_gm,M_opt)
