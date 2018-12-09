import XCTest
import HGCircularSlider
@testable import MainKit


class CircularClockSliderTests: XCTestCase {
    
    let sut = CircularClockViewController.storyboardInstance
    override func setUp() {
        super.setUp()
        sut.view.layoutIfNeeded()
    }
    
    
    func testChangeHourLessThan10() {
        // Given
        let slider = sut.hourIndicatingSlider!
        slider.endPointValue = 8
        
        // When
        sut.hourChangeHandler(slider)
        
        // Then
        XCTAssert(sut.hourLabel.text == "08:")
    }

    func testChangeHourBiggerThan10() {
        // Given
        let slider = sut.hourIndicatingSlider!
        slider.endPointValue = 11
        
        // When
        sut.hourChangeHandler(slider)
        
        // Then
        XCTAssert(sut.hourLabel.text == "11:")
    }
    
    func testChangeMinuteLessThan10() {
        // Given
        let slider = sut.minuteIndicatingSlider!
        slider.endPointValue = 8
        
        // When
        sut.minuteChangeHandler(slider)
        
        // Then
        XCTAssert(sut.minuteLabel.text == "08")
    }
    
    func testChangeMinuteBiggerThan10() {
        // Given
        let slider = sut.minuteIndicatingSlider!
        slider.endPointValue = 11
        
        // When
        sut.minuteChangeHandler(slider)
        
        // Then
        XCTAssert(sut.minuteLabel.text == "11")
    }
    
    
    func testAMselected() {
        // Given
        let segControl = sut.amPmSgementControl!
        segControl.selectedSegmentIndex = 0
        
        // When
        sut.ampmChangeHandler(segControl)
        
        // Then
        XCTAssert(UserDefaults.standard.integer(forKey: "ampm") == 0)
    }
    
    func testPMselected() {
        // Given
        let segControl = sut.amPmSgementControl!
        segControl.selectedSegmentIndex = 1
        
        // When
        sut.ampmChangeHandler(segControl)
        
        // Then
        XCTAssert(UserDefaults.standard.integer(forKey: "ampm") == 1)
    }

}
