using System;

namespace Models
{
    [Serializable]
    public class SurveyQuestion
    {
        public int SurveyQuestionId { get; set; }
        public int SurveyQuestionTypeId { get; set; }
        public int SurveyAnswerId { get; set; }
        public int OrderId { get; set; }
        public string Question { get; set; }
        public string QuestionTitle { get; set; }
    }
}