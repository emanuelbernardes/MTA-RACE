filesWheels = {
	"files/data/donator/wheels/wheel_gn1.dff",
	"files/data/donator/wheels/wheel_gn2.dff",
	"files/data/donator/wheels/wheel_gn3.dff",
	"files/data/donator/wheels/wheel_gn4.dff",
	"files/data/donator/wheels/wheel_gn5.dff",
	"files/data/donator/wheels/wheel_lr1.dff",
	"files/data/donator/wheels/wheel_lr2.dff",
	"files/data/donator/wheels/wheel_lr3.dff",
	"files/data/donator/wheels/wheel_lr4.dff",
	"files/data/donator/wheels/wheel_lr5.dff",
	"files/data/donator/wheels/wheel_or1.dff",
	"files/data/donator/wheels/wheel_sr1.dff",
	"files/data/donator/wheels/wheel_sr2.dff",
	"files/data/donator/wheels/wheel_sr3.dff",
	"files/data/donator/wheels/wheel_sr4.dff",
	"files/data/donator/wheels/wheel_sr5.dff",
	"files/data/donator/wheels/wheel_sr6.dff"
}
function getWheelsSize(player)
	local info = {}
	for i,file in pairs(filesWheels) do
		local dff = fileOpen(file,true)
		local size = fileGetSize(dff)
		table.insert(info,{name=file,size=size})
		fileClose(dff)
	end
	if player then
	    callClientFunction(player,"setWheelsSize",info)
	end
end