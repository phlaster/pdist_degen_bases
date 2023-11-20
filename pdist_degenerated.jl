#!/usr/bin/env julia
using FastaIO
using DelimitedFiles
using Pipe: @pipe


function FastaToRam(filename::String, n_max)
    sequences = []
    FastaReader(filename) do f
        for ((_, seq), _) in zip(f, 1:n_max)
            push!(sequences, toint(seq))
        end
    end
    return sequences
end

function toint(seq::String, alphabet=
            Dict(
                '-'=>0,
                'A'=>1,
                'C'=>2,
                'G'=>3,
                'T'=>4,
                'R'=>5,
                'Y'=>6,
                'M'=>7,
                'K'=>8,
                'S'=>9,
                'W'=>10,
            )
    )
    return [alphabet[i] for i in seq]
end

function pdist(seq1, seq2)
    diff = 0
    total = 0
    @inbounds @simd for i in eachindex(seq1, seq2)
        x = (seq1[i] + seq2[i]) != 0
        diff += x & (seq1[i] != seq2[i])
        total += x
    end
    total > 0 ? diff/total : 0.0
end

function p_matrix(sequences, n_max)
    matrix = zeros(undef, n_max, n_max)
    seq1 = []
    seq2 = []
    for i = 1:n_max
        seq1 = sequences[i]
        for j = i+1:n_max
            seq2 = sequences[j]
            dist = pdist(seq1, seq2)
            matrix[i, j]  = matrix[j, i] = dist
        end
    end
    return matrix
end

function main()
    @pipe readchomp(`grep -c '>' $(ARGS[1])`) |>
        (n_max = parse(Int, _))               |>
        FastaToRam(ARGS[1], _)                |>
        p_matrix(_, n_max)                    |>
        writedlm(stdout,  _, ' ')
end


if abspath(PROGRAM_FILE) == @__FILE__
    try
        main()
    catch err
        @error err
    end
end