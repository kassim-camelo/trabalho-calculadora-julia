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
    priority = []
    openParent = findall(isequal('('), collect(expression))
    closeParent = findall(isequal(')'), collect(expression))
    println("openParent: ", openParent)
    println("closeParent: ", closeParent)
    for i in eachindex(openParent)
        push!(priority, join(expression[openParent[i]+1:closeParent[i]-1]))
        if i < openParent[i] && expression[openParent[i]-1] in symbols
            push!(priority, expression[1:openParent[i]-1])          
        elseif i < openParent[i] && expression[openParent[i]-1] in numbers
            push!(priority, expression[1:openParent[i]-1])
        elseif expression[closeParent[i]+1] in symbols && i > closeParent[i]
            push!(priority, expression[closeParent[i]+1:openParent[i]-1])
        elseif expression[closeParent[i]+1] in numbers && i > closeParent[i]
            push!(priority, expression[closeParent[i]+1:openParent[i]-1])
        end
    end
    println(priority)
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
    end    
    priority = define_prio(arg)
    for i in eachindex(priority)
        res = resolve(priority[i])
        push!(final_expression, res)
    end
    println("final_expression: ", final_expression)
end

main(expr)