struct TerminalPresenter <: Presenter
end
struct BrowserPresenter <: Presenter
end
@enum YesNoCancel yes=1 no=0 cancel=-1

# TODO: use https://juliagizmos.github.io/Interact.jl/latest/widgets.html#InteractBase.checkboxes
# to display ingredients and let contents of barcabinet be indicated by checked checkboxes. Possibly use for selecting ingredients to include in recipe
# TODO: On checkbox, update barcabinet
# TODO: Button for Add: Recipe, Ingredient
# TODO: Interface for updateing all fields of Recipe
# TODO: Menu items for save and load files



# Presenter interface specification =====================
error(p::Presenter, msg) = error("error not defined for ::$(typeof(p))")
info(p::Presenter, msg) = error("info not defined for ::$(typeof(p))")
prompt(p::Presenter, msg)::String = error("prompt not defined for ::$(typeof(p))")
prompt(p::Presenter, ::Type{YesNoCancel}, msg)::YesNoCancel = error("yesnocancel not defined for ::$(typeof(p))")


# TerminalPresenter implementation
error(p::TerminalPresenter, msg) = @error(msg)
info(p::TerminalPresenter, msg)  = @info(msg)

function prompt(p::TerminalPresenter, msg)::String
    println(msg)
    readline(stdin)
end

function prompt(p::TerminalPresenter, ::Type{YesNoCancel}, msg)::YesNoCancel
    println(msg)
    print("yes/no/cancel (y/n/c)? ")
    r = lowercase(readline(stdin)[1])
    r == 'y' ? yes : r == 'n' ? no : cancel
end
