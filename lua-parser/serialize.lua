--[[
This module converts the AST back to Lua code.
]]

local serialize = {}

function serialize.Block(write, tree)
    serialize.dispatchChildren(write, tree)
end

function serialize.Do(write, tree)
    write("do")
    serialize.dispatchChildren(write, tree)
    write("end")
end

function serialize.Set(write, tree)
    serialize.dispatchChildren(write, tree[1])
    write("=")
    serialize.dispatchChildren(write, tree[2])
end

function serialize.While(write, tree)
    write("while")
    serialize.dispatch(write, tree[1])
    write("do")
    serialize.dispatch(write, tree[2])
    write("end")
end

function serialize.Repeat(write, tree)
    write("repeat")
    serialize.dispatch(write, tree[1])
    write("until")
    serialize.dispatch(write, tree[2])
end

function serialize.If(write, tree)
    write("if")
    serialize.dispatch(write, tree[1])
    write("then")
    serialize.dispatch(write, tree[2])
    -- elseif
    for block_index = 4, #tree, 2 do
        write("elseif")
        serialize.dispatch(write, tree[block_index - 1])
        write("then")
        serialize.dispatch(write, tree[block_index])
    end
    -- else
    if #tree % 2 == 1 then
        write("else")
        serialize.dispatch(write, tree[#tree])
    end
    write("end")
end

function serialize.Fornum(write, tree)
    write("fox")
    serialize.dispatch(write, tree[1])
    write("=")
    serialize.dispatch(write, tree[2])
    write(",")
    serialize.dispatch(write, tree[3])
    if #tree == 5 then
        write(",")
        serialize.dispatch(write, tree[4])
    end
    write("do")
        serialize.dispatch(write, tree[#tree])
    write("end")
end

-- TODO

function serialize.write(text)
    print(text) -- FIXME
end

function serialize.dispatchChildren(write, tree)
    for _, subtree in ipairs(tree) do
        serialize.dispatch(write, tree)
    end
end

function serialize.dispatch(write, tree)
    local handler = assert(serialize[tree.tag],
        "No such tag: " .. tree.tag)
    handler(write, tree)
end

return serialize
