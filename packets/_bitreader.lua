--[[
* Addons - Copyright (c) 2023 Ashita Development Team
* Contact: https://www.ashitaxi.com/
* Contact: https://discord.gg/Ashita
*
* This file is part of Ashita.
*
* Ashita is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Ashita is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with Ashita.  If not, see <https://www.gnu.org/licenses/>.
--]]

require('common');

local bitreader = T{
    data    = nil,
    bit     = 0,
    pos     = 0,
};

--[[
* Creates and returns a new bit reader instance.
*
* @param {table} o - The default object table, if provided.
* @return {table} The bit reader instance.
--]]
function bitreader:new(o)
    o = o or T{};

    setmetatable(o, self);
    self.__index = self;

    return o;
end


--[[
* Sets the current reader data.
*
* @param {string|table} data - The data to use with the reader. (Strings are converted to a byte table automatically.)
--]]
function bitreader:set_data(data)
    self.bit    = 0;
    self.data   = T{};
    self.pos    = 0;

    switch(type(data), T{
        ['string'] = function ()
            data:tohex():replace(' ', ''):gsub('(%x%x)', function (x)
                return table.insert(self.data, tonumber(x, 16));
            end);
        end,
        ['table'] = function ()
            self.data = data;
        end,
        [switch.default] = function ()
            error('[BitReader] Invalid data type: ' .. type(data));
        end,
    });
end

--[[
* Sets the current reader position.
*
* @param {number} pos - The byte position to set the reader to. (Resets the bit position.)
--]]
function bitreader:set_pos(pos)
    self.bit = 0;
    self.pos = pos;
end

--[[
* Reads a packed value from the current data.
*
* @param {number} bits - The number of bits to read.
* @return {number} The read value.
--]]
function bitreader:read(bits)
    local ret = 0;

    if (self.data == nil) then
        return ret;
    end

    for x = 0, bits - 1 do
        local val = bit.lshift(bit.band(self.data[self.pos + 1], 1), x);
        self.data[self.pos + 1] = bit.rshift(self.data[self.pos + 1], 1);
        ret = bit.bor(ret, val);

        self.bit = self.bit + 1;
        if (self.bit == 8) then
            self.bit = 0;
            self.pos = self.pos + 1;
        end
    end

    return ret;
end

-- Return the BitReader table..
return bitreader;