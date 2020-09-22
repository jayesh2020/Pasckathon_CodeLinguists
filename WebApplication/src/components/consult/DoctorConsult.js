import React,{ useState, useEffect } from 'react';
import Questionaire from './Questionaire';
import { connect } from 'react-redux';
import { getDoctors, getDoctor,bookAppointment } from '../../actions/doctorSearch';

const DoctorConsult = ({history,match, predict,auth,getDoctor, doctorSearch, bookAppointment}) => {
    const [toggler,setToggler] = useState(false);
    const [selectDate,setSelectDate] = useState('');
    const [timeSlot,setTimeSlot] = useState('');
    const formatDate = (date) => {
        var d = new Date(date),
            month = '' + (d.getMonth() + 1),
            day = '' + d.getDate(),
            year = d.getFullYear();
    
        if (month.length < 2) 
            month = '0' + month;
        if (day.length < 2) 
            day = '0' + day;
    
        return [year, month, day].join('-');
    }
    var curDate = new Date();
    var delayDate = new Date();
    delayDate.setDate(delayDate.getDate() + 7);
    curDate = formatDate(curDate);
    delayDate = formatDate(delayDate);
    const createSlots = (slotConfig) => {
        var slotConfig = {
            "configSlotHours":"00",
            "configSlotMinutes":"30",
            "configSlotPreparation":"0",
            "timeArr": [
            {"startTime":selectedDoctor.startTime, "endTime":selectedDoctor.endTime}
            ]
        }
        // Getting values from slotConfig using destructuring
       const {configSlotHours,configSlotMinutes,configSlotPreparation,timeArr} = slotConfig;
   
       // This is the default date that we are using to make use of javascript date functions
       // slotsArray will hold final slots
       // _timeArrStartTime is used to store start time date object from the timeArr
       // _timeArrEndTime is used to store end time date object from the timeArr
       // _tempSlotStartTime is used to create slots by adding config values and check that the time is less than the end time and lies withing the duration specified
       // _startSlot holds value of start date time of slot
       // _endSlot holds value of end date time of slot
   
       let defaultDate = new Date().toISOString().substring(0,10)
       let slotsArray = []
       let _timeArrStartTime;
       let _timeArrEndTime;
       let _tempSlotStartTime;
       let _endSlot;
       let _startSlot;
   
       // Loop over timeArr
       for (var i = 0; i < timeArr.length; i++) {
   
          // Creating time stamp using time from timeArr and default date
          _timeArrStartTime = (new Date(defaultDate + " " + timeArr[i].startTime )).getTime();
          _timeArrEndTime = (new Date(defaultDate + " " + timeArr[i].endTime)).getTime();
          _tempSlotStartTime = _timeArrStartTime;
   
          // Loop around till _tempSlotStartTime is less end time from timeArr
          while ((new Date(_tempSlotStartTime)).getTime() < (new Date(_timeArrEndTime)).getTime()) {
   
            _endSlot = new Date(_tempSlotStartTime);
            _startSlot = new Date(_tempSlotStartTime);
   
            //Adding minutes and hours from config to create slot and overiding the value of _tempSlotStartTime
            _tempSlotStartTime = _endSlot.setHours(parseInt(_endSlot.getHours()) + parseInt(configSlotHours));
            _tempSlotStartTime = _endSlot.setMinutes(parseInt(_endSlot.getMinutes()) + parseInt(configSlotMinutes));
   
            // Check _tempSlotStartTime is less than end time after adding minutes and hours, if true push into slotsArr
            if (((new Date(_tempSlotStartTime)).getTime() <= (new Date(_timeArrEndTime)).getTime())) {
   
              // DateTime object is converted to time with the help of javascript functions
              // If you want 24 hour format you can pass hour12 false
              slotsArray.push({
                "timeSlotStart": new Date(_startSlot).toLocaleTimeString('en-US', {
                  hour: 'numeric',
                  minute: 'numeric',
                  hour12: true
                }),
                "timeSlotEnd": _endSlot.toLocaleTimeString('en-US', {
                  hour: 'numeric',
                  minute: 'numeric',
                  hour12: true
                })
             });
      }
   
            //preparation time is added in last to maintain the break period
            _tempSlotStartTime = _endSlot.setMinutes(_endSlot.getMinutes() + parseInt(configSlotPreparation));
          }
       }
   
     return slotsArray;
   }
   var lis = [];
   const [slots,setSlots] = useState([]);
    useEffect(() => {
        const id = match.params.id;
        console.log(id);
        getDoctor(id);
    },[]);
    const { selectedDoctor,questions } = doctorSearch;
    useEffect(() => {
        if(selectedDoctor){
            lis = selectedDoctor.appointments[`${selectDate}`];
            console.log(lis);
        }
    },[selectedDoctor,lis,selectDate]);
    useEffect(() => {
        if(questions){
            setToggler(true);
            const slo = createSlots();
            console.log(slo);
            setSlots(slo);
        }
    },[questions]);

    const book = (timeSlotStart) => {
        var lis = selectedDoctor.appointments[`${selectDate}`];
        setTimeSlot(timeSlotStart);
        console.log(lis);
        if(lis) {
            lis = [...lis, `${timeSlotStart}`]
        } else {
            lis = [`${timeSlotStart}`]
        }
        selectedDoctor.appointments[`${selectDate}`] = lis;
/*            if(selectedDoctor.appointments[`${selectDate}`]){
                selectedDoctor.appointments[`${selectDate}`] = [`${timeSlotStart}`]
            } else {
                selectedDoctor.appointments = {
                    ...selectedDoctor.appointments,
                    [`${selectDate}`]: [...[`${selectDate}`],[`${timeSlotStart}`]]
                }
            }
*/
            console.log(selectedDoctor);

    }
    
    const submitRes = (e) => {
        e.preventDefault();
        console.log(selectDate);
        if(timeSlot && selectDate){
            bookAppointment({selectedDoctor, predict, timeSlot, dateOf: selectDate, patientUid:auth.uid, doctorUid: selectedDoctor.uid});
            history.push('/dashboard');
        }
    }

    return (
        <div>
            {!toggler && <Questionaire />}
            {toggler && selectedDoctor && <div>
                <img src={selectedDoctor.profilePic} />
                <p>{selectedDoctor.name}</p>
                <input type="date" value={selectDate} onChange={(e) => setSelectDate(e.target.value)} max={delayDate} min={curDate} />
                {selectDate && <p>Slots:</p>}
                {selectDate && slots.map(slot => 
                    <button
                    disabled={lis.includes(slot.timeSlotStart)}
                    onClick={(e) => {
                    e.preventDefault();
                    book(slot.timeSlotStart);
                }}>{slot.timeSlotStart}</button>)}
            </div>}
            <button onClick={submitRes}>Submit</button>
        </div>
    )
}

const mapStateToProps = (state) => ({
    doctorSearch: state.doctorSearch,
    auth: state.auth,
    predict: state.predict
});

const mapDispatchToProps = (dispatch) => ({
    getDoctor: (uid) => dispatch(getDoctor(uid)),
    bookAppointment: (data) => dispatch(bookAppointment(data))
});

export default connect(mapStateToProps,mapDispatchToProps)(DoctorConsult);
