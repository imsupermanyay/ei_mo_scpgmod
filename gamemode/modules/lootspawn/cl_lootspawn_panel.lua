--[[
    Loot Spawn System - Client Panel
    战利品组管理界面 + 点位列表 + 编辑模式控制
]]

LOOTSPAWN.ClientGroups = LOOTSPAWN.ClientGroups or {}
LOOTSPAWN.ClientSpawns = LOOTSPAWN.ClientSpawns or {}
LOOTSPAWN.EditMode = false
LOOTSPAWN.EditGroup = "" -- 当前编辑模式选中的组

-- ==================== 接收数据 ====================

net.Receive("lootspawn_sync_groups", function()
    local dataLen = net.ReadUInt(32)
    local raw = net.ReadData(dataLen)
    LOOTSPAWN.ClientGroups = util.JSONToTable(raw) or {}
end)

net.Receive("lootspawn_sync_spawns", function()
    local dataLen = net.ReadUInt(32)
    local raw = net.ReadData(dataLen)
    LOOTSPAWN.ClientSpawns = util.JSONToTable(raw) or {}
end)

net.Receive("lootspawn_open_panel", function()
    LOOTSPAWN.OpenMainPanel()
end)

-- ==================== 主面板 ====================

function LOOTSPAWN.OpenMainPanel()
    if IsValid(LOOTSPAWN.MainFrame) then LOOTSPAWN.MainFrame:Remove() end

    local frame = vgui.Create("DFrame")
    frame:SetSize(900, 620)
    frame:Center()
    frame:SetTitle("LootSpawn - 物品刷新配置系统")
    frame:MakePopup()
    frame:SetDeleteOnClose(true)
    LOOTSPAWN.MainFrame = frame

    local sheet = vgui.Create("DPropertySheet", frame)
    sheet:Dock(FILL)
    sheet:DockMargin(4, 4, 4, 4)

    local groupPanel = LOOTSPAWN.CreateGroupPanel(sheet)
    sheet:AddSheet("战利品组管理", groupPanel, "icon16/box.png")

    local spawnPanel = LOOTSPAWN.CreateSpawnPanel(sheet)
    sheet:AddSheet("点位管理 (" .. game.GetMap() .. ")", spawnPanel, "icon16/world.png")
end

-- ==================== 战利品组面板 ====================

function LOOTSPAWN.CreateGroupPanel(parent)
    local panel = vgui.Create("DPanel", parent)
    panel:Dock(FILL)
    panel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40))
    end

    -- 左侧：组列表
    local leftPanel = vgui.Create("DPanel", panel)
    leftPanel:Dock(LEFT)
    leftPanel:SetWide(240)
    leftPanel:DockMargin(4, 4, 4, 4)
    leftPanel.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(50, 50, 50))
    end

    local listLabel = vgui.Create("DLabel", leftPanel)
    listLabel:Dock(TOP)
    listLabel:DockMargin(8, 8, 8, 4)
    listLabel:SetText("战利品组列表")
    listLabel:SetFont("DermaDefaultBold")

    local groupList = vgui.Create("DListView", leftPanel)
    groupList:Dock(FILL)
    groupList:DockMargin(4, 4, 4, 4)
    groupList:AddColumn("Classname")
    groupList:AddColumn("名称")
    groupList:SetMultiSelect(false)

    local btnNew = vgui.Create("DButton", leftPanel)
    btnNew:Dock(BOTTOM)
    btnNew:DockMargin(4, 4, 4, 4)
    btnNew:SetTall(30)
    btnNew:SetText("+ 新建战利品组")

    -- 右侧：编辑区
    local rightPanel = vgui.Create("DPanel", panel)
    rightPanel:Dock(FILL)
    rightPanel:DockMargin(0, 4, 4, 4)
    rightPanel.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(50, 50, 50))
    end

    local editLabel = vgui.Create("DLabel", rightPanel)
    editLabel:Dock(TOP)
    editLabel:DockMargin(8, 8, 8, 4)
    editLabel:SetText("选择一个组进行编辑")
    editLabel:SetFont("DermaDefaultBold")

    local editScroll = vgui.Create("DScrollPanel", rightPanel)
    editScroll:Dock(FILL)
    editScroll:DockMargin(4, 4, 4, 4)

    local editContainer = vgui.Create("DPanel", editScroll)
    editContainer:Dock(TOP)
    editContainer:SetTall(500)
    editContainer.Paint = function() end
    editContainer:SetVisible(false)

    -- Classname
    local lblCls = vgui.Create("DLabel", editContainer)
    lblCls:Dock(TOP)
    lblCls:DockMargin(4, 8, 4, 0)
    lblCls:SetText("Classname (唯一标识，创建后不可修改)")

    local txtClassname = vgui.Create("DTextEntry", editContainer)
    txtClassname:Dock(TOP)
    txtClassname:DockMargin(4, 2, 4, 4)
    txtClassname:SetTall(24)

    -- Name
    local lblName = vgui.Create("DLabel", editContainer)
    lblName:Dock(TOP)
    lblName:DockMargin(4, 4, 4, 0)
    lblName:SetText("显示名称")

    local txtName = vgui.Create("DTextEntry", editContainer)
    txtName:Dock(TOP)
    txtName:DockMargin(4, 2, 4, 4)
    txtName:SetTall(24)

    -- 物品列表
    local lblItems = vgui.Create("DLabel", editContainer)
    lblItems:Dock(TOP)
    lblItems:DockMargin(4, 8, 4, 0)
    lblItems:SetText("物品列表 (实体classname + 权重)")
    lblItems:SetFont("DermaDefaultBold")

    local itemListView = vgui.Create("DListView", editContainer)
    itemListView:Dock(TOP)
    itemListView:DockMargin(4, 4, 4, 4)
    itemListView:SetTall(200)
    itemListView:AddColumn("实体 Classname"):SetWidth(350)
    itemListView:AddColumn("权重"):SetWidth(80)
    itemListView:SetMultiSelect(false)

    -- 添加物品行
    local addItemPanel = vgui.Create("DPanel", editContainer)
    addItemPanel:Dock(TOP)
    addItemPanel:DockMargin(4, 0, 4, 4)
    addItemPanel:SetTall(28)
    addItemPanel.Paint = function() end

    local txtItemClass = vgui.Create("DTextEntry", addItemPanel)
    txtItemClass:Dock(LEFT)
    txtItemClass:SetWide(300)
    txtItemClass:SetPlaceholderText("实体classname")

    local txtItemWeight = vgui.Create("DTextEntry", addItemPanel)
    txtItemWeight:Dock(LEFT)
    txtItemWeight:DockMargin(4, 0, 0, 0)
    txtItemWeight:SetWide(60)
    txtItemWeight:SetPlaceholderText("权重")
    txtItemWeight:SetNumeric(true)

    local btnAddItem = vgui.Create("DButton", addItemPanel)
    btnAddItem:Dock(LEFT)
    btnAddItem:DockMargin(4, 0, 0, 0)
    btnAddItem:SetWide(60)
    btnAddItem:SetText("添加")

    local btnRemoveItem = vgui.Create("DButton", editContainer)
    btnRemoveItem:Dock(TOP)
    btnRemoveItem:DockMargin(4, 0, 4, 4)
    btnRemoveItem:SetTall(24)
    btnRemoveItem:SetText("删除选中物品")

    -- 保存 / 删除
    local btnBar = vgui.Create("DPanel", editContainer)
    btnBar:Dock(TOP)
    btnBar:DockMargin(4, 8, 4, 4)
    btnBar:SetTall(32)
    btnBar.Paint = function() end

    local btnSave = vgui.Create("DButton", btnBar)
    btnSave:Dock(LEFT)
    btnSave:SetWide(120)
    btnSave:SetText("保存")

    local btnDelete = vgui.Create("DButton", btnBar)
    btnDelete:Dock(RIGHT)
    btnDelete:SetWide(120)
    btnDelete:SetText("删除此组")
    btnDelete:SetTextColor(Color(255, 80, 80))

    -- ==================== 逻辑 ====================

    local currentItems = {}
    local isNewGroup = false

    local function RefreshGroupList()
        groupList:Clear()
        for classname, data in pairs(LOOTSPAWN.ClientGroups) do
            groupList:AddLine(classname, data.name or classname)
        end
    end

    local function LoadGroupToEditor(classname)
        local data = LOOTSPAWN.ClientGroups[classname]
        if not data then return end

        isNewGroup = false
        editContainer:SetVisible(true)
        editLabel:SetText("编辑: " .. (data.name or classname))

        txtClassname:SetText(classname)
        txtClassname:SetEnabled(false)
        txtName:SetText(data.name or "")

        currentItems = {}
        itemListView:Clear()
        if data.items then
            for _, item in ipairs(data.items) do
                table.insert(currentItems, { class = item.class, weight = item.weight or 1 })
                itemListView:AddLine(item.class, item.weight or 1)
            end
        end
    end

    groupList.OnRowSelected = function(_, _, row)
        LoadGroupToEditor(row:GetColumnText(1))
    end

    btnNew.DoClick = function()
        isNewGroup = true
        editContainer:SetVisible(true)
        editLabel:SetText("新建战利品组")
        txtClassname:SetText("")
        txtClassname:SetEnabled(true)
        txtName:SetText("")
        currentItems = {}
        itemListView:Clear()
    end

    btnAddItem.DoClick = function()
        local cls = txtItemClass:GetText()
        local w = tonumber(txtItemWeight:GetText()) or 1
        if cls == "" then return end
        table.insert(currentItems, { class = cls, weight = w })
        itemListView:AddLine(cls, w)
        txtItemClass:SetText("")
        txtItemWeight:SetText("")
    end

    btnRemoveItem.DoClick = function()
        local lineId = groupList:GetSelectedLine()
        local selLine = itemListView:GetSelectedLine()
        if not selLine then return end
        table.remove(currentItems, selLine)
        itemListView:Clear()
        for _, item in ipairs(currentItems) do
            itemListView:AddLine(item.class, item.weight)
        end
    end

    btnSave.DoClick = function()
        local classname = txtClassname:GetText()
        local name = txtName:GetText()
        if classname == "" then Derma_Message("Classname 不能为空", "错误", "确定") return end
        if #currentItems == 0 then Derma_Message("至少需要一个物品", "错误", "确定") return end

        local data = util.TableToJSON({
            classname = classname,
            name = name,
            items = currentItems
        })

        net.Start("lootspawn_save_group")
            net.WriteUInt(#data, 32)
            net.WriteData(data, #data)
        net.SendToServer()

        LOOTSPAWN.ClientGroups[classname] = {
            classname = classname,
            name = name,
            items = table.Copy(currentItems)
        }
        RefreshGroupList()
    end

    btnDelete.DoClick = function()
        local classname = txtClassname:GetText()
        if classname == "" then return end
        Derma_Query("确定要删除战利品组 '" .. classname .. "' 吗？", "确认删除",
            "确定", function()
                net.Start("lootspawn_delete_group")
                    net.WriteString(classname)
                net.SendToServer()
                LOOTSPAWN.ClientGroups[classname] = nil
                RefreshGroupList()
                editContainer:SetVisible(false)
                editLabel:SetText("选择一个组进行编辑")
            end,
            "取消", function() end
        )
    end

    RefreshGroupList()
    return panel
end

-- ==================== 点位管理面板（含编辑模式） ====================

function LOOTSPAWN.CreateSpawnPanel(parent)
    local panel = vgui.Create("DPanel", parent)
    panel:Dock(FILL)
    panel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(40, 40, 40))
    end

    -- 顶部：编辑模式控制
    local topBar = vgui.Create("DPanel", panel)
    topBar:Dock(TOP)
    topBar:SetTall(80)
    topBar:DockMargin(4, 4, 4, 0)
    topBar.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(50, 50, 50))
    end

    local lblEditInfo = vgui.Create("DLabel", topBar)
    lblEditInfo:Dock(TOP)
    lblEditInfo:DockMargin(8, 6, 8, 0)
    lblEditInfo:SetText("编辑模式：关闭面板后，左键点地面放置点位，右键点击点位附近删除，按 F4 退出编辑模式")
    lblEditInfo:SetWrap(true)
    lblEditInfo:SetAutoStretchVertical(true)

    -- 组选择 + 按钮行
    local ctrlBar = vgui.Create("DPanel", topBar)
    ctrlBar:Dock(BOTTOM)
    ctrlBar:SetTall(32)
    ctrlBar:DockMargin(4, 4, 4, 4)
    ctrlBar.Paint = function() end

    local comboGroup = vgui.Create("DComboBox", ctrlBar)
    comboGroup:Dock(LEFT)
    comboGroup:SetWide(300)
    comboGroup:SetValue("选择要绑定的战利品组...")

    local function RefreshCombo()
        comboGroup:Clear()
        for classname, data in pairs(LOOTSPAWN.ClientGroups or {}) do
            comboGroup:AddChoice((data.name or classname) .. " [" .. classname .. "]", classname)
        end
    end
    RefreshCombo()

    comboGroup.OnSelect = function(_, _, _, data)
        LOOTSPAWN.EditGroup = data
    end

    local btnToggleEdit = vgui.Create("DButton", ctrlBar)
    btnToggleEdit:Dock(LEFT)
    btnToggleEdit:DockMargin(8, 0, 0, 0)
    btnToggleEdit:SetWide(180)

    local function UpdateEditButton()
        if LOOTSPAWN.EditMode then
            btnToggleEdit:SetText("■ 退出编辑模式")
            btnToggleEdit:SetTextColor(Color(255, 80, 80))
        else
            btnToggleEdit:SetText("▶ 进入编辑模式")
            btnToggleEdit:SetTextColor(Color(80, 255, 80))
        end
    end
    UpdateEditButton()

    btnToggleEdit.DoClick = function()
        if not LOOTSPAWN.EditMode and (LOOTSPAWN.EditGroup == "" or not LOOTSPAWN.EditGroup) then
            Derma_Message("请先选择一个战利品组", "提示", "确定")
            return
        end

        LOOTSPAWN.EditMode = not LOOTSPAWN.EditMode
        UpdateEditButton()

        net.Start("lootspawn_edit_mode")
            net.WriteBool(LOOTSPAWN.EditMode)
        net.SendToServer()

        if LOOTSPAWN.EditMode then
            -- 关闭面板进入编辑
            if IsValid(LOOTSPAWN.MainFrame) then
                LOOTSPAWN.MainFrame:Close()
            end
        end
    end

    -- 点位列表
    local spawnList = vgui.Create("DListView", panel)
    spawnList:Dock(FILL)
    spawnList:DockMargin(4, 4, 4, 4)
    spawnList:AddColumn("ID"):SetWidth(50)
    spawnList:AddColumn("位置"):SetWidth(300)
    spawnList:AddColumn("绑定组"):SetWidth(200)
    spawnList:SetMultiSelect(false)

    local btnDeleteSpawn = vgui.Create("DButton", panel)
    btnDeleteSpawn:Dock(BOTTOM)
    btnDeleteSpawn:DockMargin(4, 4, 4, 4)
    btnDeleteSpawn:SetTall(30)
    btnDeleteSpawn:SetText("删除选中点位")
    btnDeleteSpawn:SetTextColor(Color(255, 80, 80))

    local function RefreshSpawnList()
        spawnList:Clear()
        for _, spawn in ipairs(LOOTSPAWN.ClientSpawns) do
            local posStr = string.format("%.0f, %.0f, %.0f", spawn.pos[1], spawn.pos[2], spawn.pos[3])
            spawnList:AddLine(spawn.id, posStr, spawn.group)
        end
    end

    btnDeleteSpawn.DoClick = function()
        local lineId = spawnList:GetSelectedLine()
        if not lineId then return end
        local row = spawnList:GetLine(lineId)
        local spawnId = tonumber(row:GetColumnText(1))
        if not spawnId then return end

        Derma_Query("确定要删除点位 #" .. spawnId .. " 吗？", "确认删除",
            "确定", function()
                net.Start("lootspawn_remove_spawn")
                    net.WriteUInt(spawnId, 32)
                net.SendToServer()
                for i, s in ipairs(LOOTSPAWN.ClientSpawns) do
                    if s.id == spawnId then
                        table.remove(LOOTSPAWN.ClientSpawns, i)
                        break
                    end
                end
                RefreshSpawnList()
            end,
            "取消", function() end
        )
    end

    RefreshSpawnList()

    panel.Think = function()
        if panel._lastCount ~= #LOOTSPAWN.ClientSpawns then
            panel._lastCount = #LOOTSPAWN.ClientSpawns
            RefreshSpawnList()
            RefreshCombo()
        end
    end

    return panel
end
