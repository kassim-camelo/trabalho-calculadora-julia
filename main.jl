numbers = Set("0123456789")
operators = Set("+-*/")
symbols = Set("().")
alphabet = union!(numbers, operators, symbols)
archive = "alo.txt"
println("Enter the expression: ")
expr = readline(archive)

function is_valid_char(char)
    return char in alphabet
end

function resolve(question)
    question = filter!(!isempty, collect(question))
    if question == ""
        return "0"
    end
    operation = "."
    arg1 , arg2 = 0, 0
    for i in eachindex(question)
        if question[i] == ""
            question[i] = "0"
        end
        if question[i] in operators
            operation = question[i]
            # println("operation", operation)
            # println("typeof operation",  typeof(operation))
            index = findfirst(isequal(operation), join(question))
            # println("index", index) 
            try
                arg1 = parse(Int64, join(question[1:index-1]))
                arg2 = parse(Int64, join(question[index+1:end]))                
            catch ArgumentError
                arg1 = collect(question[1:index-1])
                arg2 = collect(question[index+1:end])
                for i in eachindex(arg1)
                    if arg1[i] in operators
                        innerOperation = arg1[i]
                        innerIndex = findfirst(isequal(innerOperation), join(arg1))
                        # println("innerIndex of arg1", innerIndex)
                        arg1_1 = parse(Int64, join(arg1[1:innerIndex-1]))
                        arg1_2 = parse(Int64, join(arg1[innerIndex+1:end]))
                        if innerOperation == '+'
                            arg1 = string(arg1_1 + arg1_2)
                            break
                        elseif innerOperation == '-'
                            arg1 = string(arg1_1 - arg1_2)
                            break
                        elseif innerOperation == '*'
                            arg1 = string(arg1_1 * arg1_2)
                            break
                        elseif innerOperation == '/'
                            arg1 = string(arg1_1 / arg1_2)
                            break
                        end     
                    end
                end
                for i in eachindex(arg2)
                    if arg2[i] in operators
                        innerOperation = arg2[i]
                        innerIndex = findfirst(isequal(innerOperation), join(arg2))
                        # println("innerIndex of arg2", innerIndex)
                        arg2_1 = parse(Int64, join(arg2[1:innerIndex-1]))
                        arg2_2 = parse(Int64, join(arg2[innerIndex+1:end]))
                        if innerOperation == '+'
                            arg2 = string(arg2_1 + arg2_2)
                            # println("arg2 inside arg2[i]: ", arg2, " as the result of ", arg2_1, '+', arg2_2)
                            break
                        elseif innerOperation == '-'
                            arg2 = string(arg2_1 - arg2_2)
                            # println("arg2 inside arg2[i]: ", arg2, " as the result of ", arg2_1, '-', arg2_2)

                            break
                        elseif innerOperation == '*'
                            arg2 = string(arg2_1 * arg2_2)
                            # println("arg2 inside arg2[i]: ", arg2, " as the result of ", arg2_1, '*', arg2_2)
                            break
                        elseif innerOperation == '/'
                            arg2 = string(arg2_1 / arg2_2)
                            # println("arg2 inside arg2[i]: ", arg2, " as the result of ", arg2_1, '/', arg2_2)
                            break
                        end
                    end
                end
                arg1 = parse(Int64, join(arg1))
                arg2 = parse(Int64, join(arg2))
                # println("AAAAAAAAA DEU BOM")
            end
            # println("arg1: ", arg1)
            # println("arg2: ", arg2)
            if operation == '+'
                return string(arg1 + arg2)
            elseif operation == '-'
                return string(arg1 - arg2)
            elseif operation == '*'
                return string(arg1 * arg2)
            elseif operation == '/'
                return string(arg1 / arg2)
            end
        end
    end
end

function define_prio(expression::String)
    parser = split(expression, "(")
    priority = Dict()
    openParent = findall(isequal("("), expression)
    closeParent = findall(isequal(")"), expression)
    # TODO TO DO
    # println(priority)
    return priority
end

function main(arg::String)
    final_expression = []
    for i in eachindex(arg)
        if is_valid_char(arg[i])
            if arg[i] in symbols
                printstyled(arg[i], " is a symbol\n", color=:green)
            elseif arg[i] in operators
                printstyled(arg[i], " is an operator\n", color=:green)
            elseif arg[i] in numbers
                printstyled(arg[i], " is a number\n", color=:green)
            end
        else
            printstyled("SyntaxError in char index ", i, " of ", '"',archive,'"',": ","'" ,expr[i],"'", "\n", color=:red)
            break
        end
        priority = define_prio(arg)
        keys = []
        for (key, value) in priority
            push!(keys, key)
        end
        keys = sort(keys)
        for (key, values) in priority
            if key in keys
                for value in values
                    if length(value) > 1
                        resolve(value)
                    end
                    push!(final_expression, value)
                end
            end
        end
    end    
    println("final_expression", final_expression)
end

main(expr)