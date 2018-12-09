import XCTest
import HGCircularSlider
import HealthKitHelper
@testable import MainKit


class CircularClockSliderTests: XCTestCase {
    
    let sut = CircularClockViewController.storyboardInstance
    
    func test1Authorization() {
        // Given
        let mockAuthRequestor = MockAuthRequestor()
        sut.authRequestor = mockAuthRequestor
        
        // When
        sut.view.layoutIfNeeded()
        
        // THen
        XCTAssert(mockAuthRequestor.authorized == false)
        
    }
    
    func testChangeHourLessThan10() {
        // Given
        sut.view.layoutIfNeeded()
        let slider = sut.hourIndicatingSlider!
        slider.endPointValue = 8

        // When
        sut.hourChangeHandler(slider)
        
        // Then
        XCTAssert(sut.hourLabel.text == "08:")
    }

    func testChangeHourBiggerThan10() {
        // Given
        sut.view.layoutIfNeeded()
        let slider = sut.hourIndicatingSlider!
        slider.endPointValue = 11

        // When
        sut.hourChangeHandler(slider)
        
        // Then
        XCTAssert(sut.hourLabel.text == "11:")
    }
    
    func testChangeMinuteLessThan10() {
        // Given
        sut.view.layoutIfNeeded()
        let slider = sut.minuteIndicatingSlider!
        slider.endPointValue = 8

        // When
        sut.minuteChangeHandler(slider)
        
        // Then
        XCTAssert(sut.minuteLabel.text == "08")
    }
    
    func testChangeMinuteBiggerThan10() {
        // Given
        sut.view.layoutIfNeeded()
        let slider = sut.minuteIndicatingSlider!
        slider.endPointValue = 11

        // When
        sut.minuteChangeHandler(slider)
        
        // Then
        XCTAssert(sut.minuteLabel.text == "11")
    }
    
    
    func testAMselected() {
        // Given
        sut.view.layoutIfNeeded()
        let segControl = sut.amPmSgementControl!
        segControl.selectedSegmentIndex = 0

        // When
        sut.ampmChangeHandler(segControl)
        
        // Then
        XCTAssert(UserDefaults.standard.integer(forKey: "ampm") == 0)
    }
    
    func testPMselected() {
        // Given
        sut.view.layoutIfNeeded()
        let segControl = sut.amPmSgementControl!
        segControl.selectedSegmentIndex = 1

        // When
        sut.ampmChangeHandler(segControl)
        
        // Then
        XCTAssert(UserDefaults.standard.integer(forKey: "ampm") == 1)
    }

}

class MockAuthRequestor: HealthKitAuthRequestor {
    var authorized = true
    func requestSleepAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        authorized = false
        completion(authorized, MockError.unkown)
    }
    
    enum MockError: Error {
        case unkown
        var localizedDescription: String {
            return "Unknwon Error Occured!"
        }
    }
}
