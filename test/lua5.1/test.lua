local kafka = require 'kafka'
print('Using kafka ' .. kafka.version())

local brokerlist    = "localhost:9092"
local producer_conf = {
    ["queue.buffering.max.messages"] = 20000,
    ["batch.num.messages"] = 200,
    ["message.max.bytes"] = 1024 * 1024,
    ["queue.buffering.max.ms"] = 10,
    ["topic.metadata.refresh.interval.ms"] = -1,
}
local producer = kafka.producer(brokerlist, producer_conf)

-- Set the topic to work with.
local strTopic = 'muhkuh-production-log'

-- Create the topic if it does not exist yet.
producer:create_topic(strTopic)

-- Produce some demo messages.
for uiCnt=0,10 do
  local strMsg = string.format('Test %d', uiCnt)
  local ret = producer:send(strTopic, -1, uiCnt, strMsg)
  print(ret)

  local sequence_id, failures = producer:poll(-1)
  print(sequence_id, failures)
end

producer:destroy_topic(strTopic)
