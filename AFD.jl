# AFD - Autômato Finito Determinístico
using OrderedCollections

# M = (Q, Σ, δ, q0, F) sendo o conjunto de estados, o alfabeto, as funções de transição, 
# o estado inicial e o conjunto de estados finais, respectivamente.
numbers = Set("0123456789")
operators = Set("+-/*")
parenthesis = Set("()")
decimal = Set('.')

# Numeros = {0,1,2,3,4,5,6,7,8,9} sendo o conjunto de números
# Operadores = {+,-,*,/} sendo o conjunto de operadores
# Parenteses = {(,)} sendo o conjunto de parênteses
# Decimal = {.} sendo o conjunto de ponto
# Σ = {Números ∪ Operadores ∪ Parenteses ∪ Decimal ∪ Enter} sendo o Alfabeto
alphabet = union(numbers, operators, parenthesis, decimal)

# Q = {q0, q1, q2, q3, q4, erro} sendo: q0 o estado inicial, q1 estado de número, 
# q2 estado de parenteses, q3 estado de operador, q4 estado de resultado, q5 estado de decimal e erro estado de erro.
states = ["q0", "q1", "q2", "q3", "q4", "q5", "erro"]

# δ = {
    # δ: (q0, Número) -> q1
    # δ: (q0, Parenteses) -> q2
    # δ: (q0, Decimal) -> erro
    # δ: (q0, Enter) -> q4
    # δ: (q0, Operadores) -> erro
    
    # δ: (q1, Número) -> q1
    # δ: (q1, Parenteses) -> erro
    # δ: (q1, Decimal) -> q5
    # δ: (q1, Enter) -> q4
    # δ: (q1, Operadores) -> q3

    # δ: (q2, Número) -> q1
    # δ: (q2, Parenteses) -> q3
    # δ: (q2, Decimal) -> erro
    # δ: (q2, Enter) -> erro
    # δ: (q2, Operadores) -> erro
    
    # δ: (q3, Número) -> q1
    # δ: (q3, Parenteses) -> q1
    # δ: (q3, Decimal) -> erro
    # δ: (q3, Enter) -> erro
    # δ: (q3, Operadores) -> q4

    # δ: (q5, Número) -> q1
    # δ: (q5, Parenteses) -> erro
    # δ: (q5, Decimal) -> erro
    # δ: (q5, Enter) -> erro
    # δ: (q5, Operadores) -> erro
# }
transition_functions = OrderedDict()

# F = {q1, q4} sendo o conjunto de estados finais de aceitação
final_states = ["q1", "q4"]

input = readline("alo.txt")

state = "q0"

function setState(symbol)
    if symbol in numbers
        return "q1"
    elseif symbol in parenthesis
        return "q2"
    elseif symbol in operators
        return "q3"
    elseif symbol in enter
        return "q4"
    elseif symbol in decimal
        return "q5"
    end
end

for symbol in input
    if symbol in alphabet
        push!(transition_functions, (state, symbol) => setState(symbol))
        global state = setState(symbol)
    else
        error("SymbolError: Symbol $symbol not in alphabet")
    end
end

println("transition_functions: ", transition_functions)

for i in transition_functions
    println("key: ", i.first, ", value: ", i.second)
end