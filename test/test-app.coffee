vows = require 'vows'
assert = require 'assert'
lib = require '../applib'
util = require 'util'

vows
  .describe('CureBlog main app')
  .addBatch
    'listfile for list1':
      topic: -> (lib.listfile 'datatest/list1')                

      'returns two items': (topic) ->
        console.log util.inspect topic
        assert.equal topic.length, 2

    ###
    'but when divizing zero by zero':
      topic: -> 0 / 0

      'we get a value which':
        'is not a number': (topic) ->
          assert.isNaN topic

        'is not equal to itself': (topic) ->
          assert.notEqual topic, topic
    ###

  .export module

