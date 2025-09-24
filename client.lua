-- Boat Fuel Manager - CLIENT SIDE
-- Ensures all boats always have 100% fuel

local boatClasses = {
    [14] = true -- Boat class
}

local function isBoat(vehicle)
    return boatClasses[GetVehicleClass(vehicle)] == true
end

local function setBoatFuel(vehicle)
    if DoesEntityExist(vehicle) and isBoat(vehicle) then
        SetVehicleFuelLevel(vehicle, 100.0)
        -- Also trigger server event for ox_fuel compatibility
        TriggerServerEvent('boat-fuel:setFuel', NetworkGetNetworkIdFromEntity(vehicle))
    end
end

-- Check all existing vehicles every 5 seconds
CreateThread(function()
    while true do
        Wait(5000) -- Check every 5 seconds
        
        local vehicles = GetGamePool('CVehicle')
        for i = 1, #vehicles do
            local vehicle = vehicles[i]
            if isBoat(vehicle) then
                local fuel = GetVehicleFuelLevel(vehicle)
                if fuel < 95.0 then -- If fuel is less than 95%, refill to 100%
                    setBoatFuel(vehicle)
                end
            end
        end
    end
end)

-- Listen for when vehicles spawn
AddEventHandler('entityCreated', function(entity)
    if DoesEntityExist(entity) and GetEntityType(entity) == 2 then -- Vehicle type
        Wait(1000) -- Small delay to ensure vehicle is fully spawned
        if isBoat(entity) then
            setBoatFuel(entity)
        end
    end
end)

print("^2[Boat Fuel Manager]^7 Client started - All boats will maintain 100% fuel")