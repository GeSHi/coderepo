package rehersal.results
import rehersal.timings._

class TestsResult(val tests: Tests)
{
        private var failures = List[FailureTestResult]()
        private var successes = List[SuccesfulTestResult]()

        var onceBeforeNotes: Option[String] = None
        var onceAfterNotes: Option[String] = None
        var onceBeforeTiming: Timing = NoRecordedTiming
        var onceAfterTiming: Timing = NoRecordedTiming
        var testsTiming: Timing = NoRecordedTiming

        def noteFailedInOnceBefore(): unit =
        {
                failedInOnceBefore = true
                overallMessage = "failed in onceBefore"
        }

        def noteFailedInOnceAfter(): unit =
        {
                failedInOnceAfter = true
                overallMessage = "failed in onceAfter"
        }

        def addTestResult(testResult: TestResult): unit =
        {
                testResult match
                {
                        case testResult: FailureTestResult =>
                        {
                                failures = testResult :: failures
                                overallMessage = "has failures"
                        }
                        case testResult: SuccesfulTestResult => successes = testResult :: successes;
                }
                testsTiming = testsTiming + testResult.totalTiming
        }

        def totalTiming: Timing =
        {
                onceBeforeTiming + testsTiming + onceAfterTiming
        }

        def forEachFailure( visitor: (FailureTestResult)=>unit ) =
        {
                failures.foreach(visitor)
        }

        def forEachSuccess( visitor: (SuccesfulTestResult)=>unit ) =
        {
                successes.foreach(visitor)
        }

        var overallMessage: String = "successful"

        var failedInOnceBefore: boolean = false
        var failedInOnceAfter: boolean = false

        def noTestsRun : boolean = {failures.length == 0 && successes.length == 0 && !failedInOnceBefore && !failedInOnceAfter}

        def hasFailures : boolean = {failures.length > 0}

        def allPassed : boolean = !hasFailures

        def failureCount = failures.length

        def testsName: String = removeDollarTerminatingDollarSign(tests.getClass.getName())

        private def removeDollarTerminatingDollarSign(className: String): String =
        {
                if (className.endsWith("$"))
                {
                        className.substring(0, className.length - 1)
                }
                else
                {
                        className
                }
        }
}

