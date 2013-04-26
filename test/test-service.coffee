{Service} = require '../src/service'
{Application} = require '../src/application'

testService = () ->
  new Service('./test/app.db', './test/apps')

testList = (name) ->
  name: name
  logs:
    install: 'test/apps/' + name + '/logs/install'
    process: 'test/apps/' + name + '/logs/process'
    error: 'test/apps/' + name + '/logs/error'
  repo:
    dir: 'test/apps/' + name + '/repo'

exports.testEmptyList = (test) ->
  service = testService()
  test.equal(service.list().length, 0)
  test.done()

exports.testAddNewApplication = (test) ->
  service = testService()
  test.equal(service.create(name: 'foo'), true)
  test.deepEqual(service.list(), [testList('foo')])
  test.done()

exports.testDontAddSameTwice = (test) ->
  service = testService()
  test.equal(service.create(name: 'foo'), true)
  test.equal(service.create(name: 'foo'), false)
  test.deepEqual(service.list(), [testList('foo')])
  test.done()

exports.testFindApplication = (test) ->
  service = testService()
  test.equal(service.create(name: 'foo'), true)
  test.deepEqual(service.find('foo'), testList('foo'))
  test.done()
  
exports.testNotFindApplication = (test) ->
  service = testService()
  test.equal(service.find('foo'), undefined)
  test.done()

exports.testReplaceAnApplication = (test) ->
  service = testService()
  test.equal(service.create(name: 'foo'), true)
  test.equal(service.update('foo', name: 'foo2'), true)
  test.deepEqual(service.list(), [testList('foo2')])
  test.done()

exports.testNoReplacementIfNotExists = (test) ->
  service = testService()
  test.equal(service.update('foo', name: 'foo2'), false)
  test.equal(service.list().length, 0)
  test.done()

exports.testRemoveAnApplication = (test) ->
  service = testService()
  test.equal(service.create(name: 'foo'), true)
  test.equal(service.destroy('foo'), true)
  test.deepEqual(service.list().length, 0)
  test.done()

exports.testRemoveAnApplicationIfNotExists = (test) ->
  service = testService()
  test.equal(service.destroy('foo'), false)
  test.done()

exports.testFindApplicationObject = (test) ->
  service = testService()
  test.equal(service.create(name: 'foo'), true)
  test.deepEqual(service.app('foo'), new Application(testList('foo')))
  test.done()

exports.testNotFindApplicationObject = (test) ->
  service = testService()
  test.equal(service.app('foo'), undefined)
  test.done()