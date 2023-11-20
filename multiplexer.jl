using FastaIO


function read_single_seq(fname)
    FastaReader(fname) do fr
        return first(fr)[2]
    end
end

function write_new_dset(dset, fname)
    FastaWriter(fname) do fw
        for (id, seq) in enumerate(dset)
            writeentry(fw, "$id", seq)
        end
    end
end

function flip_nucl(seq, flip_prob=0.01)
    letters = setdiff(Set(seq), 'N')
    gapped = Char[]
    for s in seq
        if rand() < flip_prob
            push!(gapped, rand(setdiff(letters, s)))
        else
            push!(gapped, s)
        end
    end
    return join(gapped)
end

function consensus(pair)
    seq1, seq2 = pair
    cons = Char[]
    translator = Dict(
        Set(['A', 'G']) => 'R',
        Set(['C', 'T']) => 'Y',
        Set(['A', 'C']) => 'M',
        Set(['T', 'G']) => 'K',
        Set(['C', 'G']) => 'S',
        Set(['A', 'T']) => 'W',
    )

    @assert length(seq1) == length(seq2)

    for i in eachindex(seq1)
        pair = Set([seq1[i], seq2[i]])
        if pair ∈ keys(translator)
            push!(cons, translator[pair])
        else
            @assert seq1[i]==seq2[i] "Wrong letter set!"

            push!(cons, seq1[i])
        end
    end
    return join(cons)
end

function generate_pairs(reference, n_sampl)
    # Ploidy == 2
    pairs=[]
    for i in 1:n_sampl
        sample = flip_nucl(reference, 5e-2)
        push!(pairs, (sample, flip_nucl(sample, 5e-3)))
    end
    return pairs
end

rRNA = read_single_seq("16s.fasta")

pairs = generate_pairs(rRNA, 10)

dset = consensus.(pairs)

write_new_dset(dset, "16s_degenerated.fasta")

