local xml = false
function createXML()
    xml = xmlLoadFile("settings.xml")
    if not xml then
        local RootNode = xmlCreateFile("settings.xml","root")
        local options = xmlCreateChild(RootNode,"options")
        xmlNodeSetValue(xmlCreateChild(options,"water"),"false")
		xmlNodeSetValue(xmlCreateChild(options,"carmod"),"false")
		xmlNodeSetValue(xmlCreateChild(options,"carpaint"),"false")
		xmlNodeSetValue(xmlCreateChild(options,"bloom"),"false")
		xmlNodeSetValue(xmlCreateChild(options,"hdr"),"false")
		xmlNodeSetValue(xmlCreateChild(options,"skid"),"false")
		xmlNodeSetValue(xmlCreateChild(options,"snow"),"false")
		xmlNodeSetValue(xmlCreateChild(options,"huntermod"),"false")
		xmlNodeSetValue(xmlCreateChild(options,"road"),"false")
        xmlSaveFile(RootNode)
		xml = xmlLoadFile("settings.xml")
    end	
end
createXML()
function getNodeValue(name)
    if xml then
        local options = xmlFindChild(xml,"options",0)
        local child = xmlFindChild(options,name,0)
        return xmlNodeGetValue(child) or ""
	end
end
function setNodeValue(name,value)
    if xml then
        local options = xmlFindChild(xml,"options",0)
        local child = xmlFindChild(options,name,0)
        xmlNodeSetValue(child,value)
		xmlSaveFile(xml)
	end
end
function getAllNodeValue()
    local info = {}
    for i,node in pairs(xmlNodeGetChildren(xmlFindChild(xml,"options",0))) do
		table.insert(info,tostring(xmlNodeGetValue(node)))
    end
	return info
end
function startSettings()
    local info = getAllNodeValue()
	for i,value in ipairs(info) do
	    if value == "true" then
		    loadXmlSaved(i)
		end
	end
end
function loadXmlSaved(i)
    opLoops[i].state = true
    if i == 1 then
		if opLoops[i].state then
			toggleWaterShader()
		end
	end	
	if i == 2 then
		if opLoops[i].state then
			infernusModel()
		end	
	end
	if i == 3 then
		if opLoops[i].state then
			toggleCarpainShader()
		end
	end	
	if i == 4 then
		if opLoops[i].state then
			if opLoops[5].state then
				opLoops[5].state = false
				toggleHDRShader()
			end
			toggleBloomShader()
		end
	end	
	if i == 5 then
		if opLoops[i].state then
			if opLoops[4].state then
				opLoops[4].state = false
				toggleBloomShader()
			end
			toggleHDRShader()
		end
	end	
	if i == 6 then
		if opLoops[i].state then
			toggleSkidMarks()
		end
	end	
	if i == 7 then
		if opLoops[i].state then
			toggleSnowShader(opLoops[i].state)
		end
	end	
	if i == 8 then
		if opLoops[i].state then
		    hunterModel()
		end
	end	
	if i == 9 then
		if opLoops[i].state then
			loadRoadMod()
		end
	end	
end