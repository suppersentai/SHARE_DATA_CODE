// Get Firt day of week
 public DateTime firstDayOfWeek()
        {
            var today = (int)DateTime.Now.DayOfWeek;
            return DateTime.Now.AddDays(-(a - 1));
        }
        
// get start end day of Quarters, current week,  current month
public void date()
        {

            int dayOfWeek = (int)DateTime.Now.DayOfWeek;
            var firstDayOfWeek = DateTime.Now.AddDays(-(dayOfWeek - 1));
            int year = DateTime.Now.Year;
            int month = DateTime.Now.Year;
            // this week 
            var startWeek = firstDayOfWeek.ToString("dd/MM/yyyy");
            var endWeek = firstDayOfWeek.AddDays(6).ToString("dd/MM/yyyy");
            // this month 
            var startMonth = new DateTime(year,month,1);
            var endMonth = new DateTime(year, month, DateTime.DaysInMonth(year, month));
            // 1st Quarter
            var start1st= new DateTime(year, 1, 1);
            var end1st = new DateTime(year, 3, DateTime.DaysInMonth(year, 3);
            // 2st Quarter
            var start2st = new DateTime(year, 4, 1);
            var end2st = new DateTime(year, 6, DateTime.DaysInMonth(year, 6));
            // 3st Quarter
            var start3st = new DateTime(year, 7, 1);
            var end3st = new DateTime(year, 9, DateTime.DaysInMonth(year, 9));
            // 4st Quarter
            var start4st = new DateTime(year, 10, 1);
            var end4st = new DateTime(year, 12, DateTime.DaysInMonth(year, 12));


         
        }
