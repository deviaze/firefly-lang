local append = table.insert 

local bench = {}
    bench.times = {}

local m = {}
function m.__call()
	append(bench.times, os.clock())
end

function m.__tostring()
	local bt = bench.times
	local p = "Benched Times:\n"
	for i, t in bt do
		if i ~= #bt then
			p ..= ` t[{i+1}] - t[{i}] = {bt[i + 1] - t}\n`
		else
			p ..= ` t[f] - t[{i}] = {os.clock() - t}`
		end
	end
	return p
end

function bench.print()
	print(tostring(bench))
end

return setmetatable(bench,m)