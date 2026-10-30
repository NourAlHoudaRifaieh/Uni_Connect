"""Step 6: builds the full training pool and the hard test set.

Outputs (in this folder):
  posts.csv      - training pool: template-generated + hand-written + your my_posts.csv
  hard_test.csv  - 60 hand-written posts the model must NEVER train on

Labels: Exam, Assignment, Question, Announcement, General.
Each row has a "group" id (its template). Evaluation splits BY GROUP so the
same template never appears in both train and test (no leakage).

Run from the ml folder:  python data/generate_dataset.py
"""
import csv, random, os

random.seed(42)
HERE = os.path.dirname(os.path.abspath(__file__))

SUBJECTS = [
    "Financial Accounting", "Managerial Accounting", "Cost Accounting", "Auditing",
    "Microeconomics", "Macroeconomics", "Econometrics", "Monetary Economics",
    "Development Economics", "International Trade", "Money and Banking",
    "Business Statistics", "Business Mathematics", "Marketing Principles",
    "Digital Marketing", "Consumer Behavior", "Corporate Finance", "Investment Analysis",
    "Management Information Systems", "Business Law", "Operations Management",
    "Supply Chain Management", "Organizational Behavior", "Human Resource Management",
    "Strategic Management", "Entrepreneurship", "Business Ethics", "Business Communication",
    "Micro", "Macro", "Stats", "Accounting", "Marketing", "Finance", "Management", "Economics",
]
TOPICS = [
    "elasticity of demand", "GDP and inflation", "the balance sheet", "regression analysis",
    "supply and demand", "opportunity cost", "break-even analysis", "depreciation methods",
    "the 4Ps of marketing", "market segmentation", "net present value", "time value of money",
    "hypothesis testing", "probability distributions", "monetary policy", "fiscal policy",
    "perfect competition", "monopoly pricing", "the cash flow statement", "inventory valuation",
    "SWOT analysis", "Porter's five forces", "portfolio theory", "risk and return",
    "exchange rates", "comparative advantage", "contract law", "job analysis",
    "supply chain design", "database basics", "the multiplier effect", "marginal cost",
    "standard deviation", "journal entries", "ratio analysis", "unemployment",
    "interest rates", "budgeting", "forecasting", "brand positioning",
]
EXAM_TYPES = ["midterm", "final exam", "quiz", "midterm exam", "first exam", "oral exam",
              "make-up exam", "resit exam", "final", "short quiz"]
DAYS = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "next week",
        "tomorrow", "the 12th", "the 20th", "next Monday", "this Friday"]
TIMES = ["8:00 am", "9:30 am", "11 am", "12:30 pm", "2 pm", "4 pm", "5:30 pm"]
WHENS = ["tomorrow", "next week", "on Monday", "this Thursday", "in two days", "before Friday",
         "by the end of the week", "next Tuesday"]
SEMINARS = ["entrepreneurship", "financial literacy", "CV writing", "digital marketing",
            "stock market basics", "interview skills", "banking careers", "startup funding"]
ROOMS = ["A1", "B3", "C12", "204", "105", "the main hall", "lab 2", "building C"]


def fill(t):
    c1 = random.randint(1, 8)
    return t.format(
        subject=random.choice(SUBJECTS), topic=random.choice(TOPICS), topic2=random.choice(TOPICS),
        exam_type=random.choice(EXAM_TYPES), day=random.choice(DAYS), time=random.choice(TIMES),
        time2=random.choice(TIMES), when=random.choice(WHENS), room=random.choice(ROOMS),
        c1=c1, c2=c1 + random.randint(1, 3), n=random.randint(2, 8), dur=random.choice([45, 60, 90, 120]),
        seminar=random.choice(SEMINARS))


TEMPLATES = {
    "Exam": [
        "The {subject} {exam_type} will be on {day} at {time} in room {room}.",
        "{subject} {exam_type} covers chapters {c1} to {c2}. Good luck everyone.",
        "Reminder: the {subject} {exam_type} is {when}. Don't forget your student ID.",
        "I uploaded past papers for the {subject} {exam_type}, they really help.",
        "The {subject} {exam_type} results are out, check the portal.",
        "Our {subject} {exam_type} will be closed book, only a calculator is allowed.",
        "The doctor said the {subject} {exam_type} will include {topic} and {topic2}.",
        "Studying for the {subject} {exam_type} tonight, it is going to be a long night.",
        "The {subject} {exam_type} was postponed to {day}.",
        "The {subject} {exam_type} was mostly multiple choice with two problems about {topic}.",
        "Exam schedule for {subject}: {exam_type} on {day}, duration {dur} minutes.",
        "Exam week starts {when}, check your seat number for {subject}.",
        "Practice questions on {topic} for the {subject} {exam_type} are shared in the group.",
        "The {subject} {exam_type} was harder than expected, especially the {topic} part.",
        "{exam_type} in {subject} is {when}, I have not started revising {topic} yet.",
        "Study guide for the {subject} {exam_type} is on the platform, focus on {topic}.",
        "The {subject} {exam_type} will have {n} essay questions and a few calculations.",
        "Marks of the {subject} {exam_type} will be published {when}.",
        "No phones allowed in the {subject} {exam_type}, the doctor was very clear about it.",
        "Exam hall for {subject} changed to {room}, the {exam_type} starts at {time}.",
    ],
    "Assignment": [
        "The {subject} assignment is due {day}, submit it on the platform before {time}.",
        "The doctor posted a new homework in {subject} about {topic}.",
        "Group project for {subject}: each team must submit a report of {n} pages by {day}.",
        "The case study on {topic} for {subject} has to be handed in {when}.",
        "The {subject} presentation will be on {day}, groups of {n} students.",
        "Deadline for the {subject} research paper was extended to {day}.",
        "I finished the {subject} homework about {topic}, it took me almost {n} hours.",
        "Assignment {n} in {subject} requires an excel sheet with calculations on {topic}.",
        "Reminder: the {subject} project proposal is due {when}. Late submissions lose {n} points.",
        "We need to choose a company for the {subject} project, the list is in the shared sheet.",
        "The {subject} assignment must be submitted as a PDF, handwritten work is not accepted.",
        "Homework {n} for {subject} is uploaded, it covers {topic} and {topic2}.",
        "Our {subject} team is working on the {topic} report, we plan to finish by {day}.",
        "Submission link for the {subject} project is now open.",
        "The {subject} term paper should be {n} pages and include at least five references.",
        "Each student must prepare a short presentation on {topic} for {subject}, due {when}.",
        "The {subject} lab report about {topic} is due {day}.",
        "Project teams for {subject} are formed, check the sheet to see your group.",
        "I am still writing the {topic} part of our {subject} report.",
        "The doctor wants the {subject} assignment emailed before {time} on {day}.",
    ],
    "Question": [
        "Can anyone explain {topic} in {subject}?",
        "How do you calculate {topic}? I keep getting a different answer.",
        "Does anyone have the notes for {subject} chapter {c1}?",
        "What is the difference between {topic} and {topic2}?",
        "Is the {subject} {exam_type} open book or closed book?",
        "When is the {subject} {exam_type}? I can't find the date.",
        "Does anyone know which room the {subject} class is in?",
        "Can someone help me with question {n} in the {subject} homework?",
        "Which book should I use to study {subject}?",
        "Has anyone taken {subject} with this doctor before? Is it difficult?",
        "Why is {topic} important in {subject}?",
        "Any tips for studying {subject}? I am struggling.",
        "Is there a video that explains {topic} well?",
        "Can I submit the {subject} assignment late?",
        "What chapters are included in the {subject} {exam_type}?",
        "Does anyone want to form a study group for {subject}?",
        "I don't understand {topic} at all, can someone help",
        "How many pages should the {subject} report be?",
        "Who has the slides of the last {subject} lecture?",
        "Is {topic} going to be in the {subject} {exam_type}?",
        "Could someone solve an example on {topic} step by step?",
        "What is the deadline for the {subject} project? I missed the announcement.",
    ],
    "Announcement": [
        "Tomorrow's {subject} class is cancelled.",
        "The {subject} lecture has been moved to room {room} on {day}.",
        "Office hours for {subject} are every {day} from {time} to {time2}.",
        "The faculty will organize a career day on {day}, all students are invited.",
        "Registration for next semester opens on {day}.",
        "There will be no classes on {day} due to the public holiday.",
        "The {subject} doctor will be absent next week, a substitute will teach the class.",
        "The faculty library will close at {time} this week.",
        "A seminar on {seminar} will be held on {day} at {time} in {room}.",
        "The {subject} class time changed to {time} starting next week.",
        "Please bring your student ID to the faculty office to collect your documents on {day}.",
        "Students must update their academic information before {day}.",
        "The faculty is organizing a workshop about {seminar}, registration is open until {day}.",
        "The class schedule has been updated, check the new timetable on the portal.",
        "{subject} will be taught online this week, the link will be sent by email.",
        "Attention students: the deadline to withdraw from a course is {day}.",
        "A guest speaker will talk about {seminar} on {day} in {room}, attendance is open to all.",
        "The administration office will be closed on {day}.",
        "Scholarship applications are open until {day}, visit the office for details.",
        "Student council meeting is {when} at {time} in {room}.",
    ],
    "General": [
        "Good morning everyone, have a great day!",
        "Thank you all for the help yesterday, really appreciate it.",
        "I shared my {subject} summary of chapters {c1} to {c2}, hope it helps.",
        "Lost my black wallet near the cafeteria, if you find it please tell me.",
        "The cafeteria coffee is terrible today.",
        "Can't wait for the semester to finish.",
        "Proud of our class, we did great this semester.",
        "We will get through this semester together, keep going!",
        "Happy birthday to our classmate, wishing you the best!",
        "Just discovered a great quiet place to study near the faculty.",
        "Sharing a useful YouTube channel for learning {topic}.",
        "Congratulations to everyone who finished the semester.",
        "Feeling stressed lately, but we keep going.",
        "Welcome to all the new students joining the faculty!",
        "I love {subject}, best class this semester.",
        "Found a notebook in room {room}, I left it with the secretary.",
        "Sharing my notes on {topic} for {subject}, take what you need.",
        "Free PDF of a {subject} textbook, enjoy.",
        "This semester is going by so fast.",
        "Finally understood {topic} after weeks of trying, feeling proud.",
        "Wishing everyone a productive week!",
        "Nice weather today, perfect for studying outside.",
    ],
}

HANDWRITTEN = {
    "Exam": [
        "the macro midterm was easier than I thought, mostly graphs",
        "finals timetable is out and I have two exams on the same day",
        "Open book final for business law, bring the code with you",
        "Midterm of stats will include a table of formulas, no need to memorize them",
        "the doctor shared the exam format, 30 mcq and 3 problems",
        "tomorrow is the accounting quiz, good luck to all",
        "Exam results for corporate finance were posted on the portal this morning",
        "The oral exam for HR is scheduled for next Monday",
        "Mid exam of marketing covers everything until the segmentation lecture",
        "quiz 2 for micro will be during the first 20 minutes of class",
        "Make up exam for operations is on Saturday morning",
        "I have three finals in the same week, no time to breathe",
        "Final exam seats are assigned alphabetically this semester",
        "The econometrics midterm will not include the last chapter",
        "exam for entrepreneurship is a case analysis not a normal test",
    ],
    "Assignment": [
        "hw 4 for stats is uploaded please check the platform",
        "Marketing plan project is due Sunday midnight, submit one file per group",
        "the doctor extended the deadline of the finance case to Friday",
        "I'm done with my part of the group presentation, waiting for the others",
        "Assignment about the Lebanese banking sector has to be 8 pages minimum",
        "excel sheet with the loan amortization schedule is required for the project",
        "we have a new case study in strategic management about Zara",
        "The accounting homework must show all the steps, not only the final answer",
        "Please upload your project report as a single PDF before midnight",
        "Presentation order for organizational behavior is posted, we are third",
        "Our group chose Apple for the operations project",
        "individual essay on inflation is due next Wednesday",
        "The doctor wants a one page summary of the article by next class",
        "Peer evaluation form for the group project is due with the report",
        "business plan draft is due in two weeks, include a financial forecast",
    ],
    "Question": [
        "does anyone know how to solve the second question of the depreciation homework",
        "what is the difference between fixed and variable costs",
        "can somebody send me the marketing slides please, i missed class",
        "how can i calculate the price elasticity from the table",
        "is the macro exam cumulative or only the second half",
        "Which room is the finance lecture in today?",
        "any good resources for learning excel for accounting",
        "do we have class tomorrow or not",
        "anyone understands the central limit theorem, my brain is fried",
        "how many credits do I need to graduate from the economics program",
        "what time does the faculty library open",
        "is it better to take management or marketing as an elective",
        "Could you explain why interest rates affect investment",
        "has anyone started the project yet, where do I begin",
        "does the doctor allow a calculator with graphs",
    ],
    "Announcement": [
        "no lecture on Wednesday for business law, the doctor is travelling",
        "Faculty open day will be held on the 15th of November, all majors welcome",
        "new timetable is online, a few classes changed rooms",
        "The faculty office will be closed on Friday",
        "Scholarship applications are open until the end of the month",
        "Guest speaker from a local bank will talk about careers in finance next Tuesday",
        "Lab attendance is now mandatory according to the administration",
        "Class representatives are invited to a meeting tomorrow at 1 pm",
        "Marketing class will be online this week, the link will be shared by email",
        "Student council elections next week, candidates can register at the office",
        "Parking near the faculty will be restricted starting Monday",
        "The internship fair takes place on Thursday in the main hall",
        "Please check your university email for the updated academic calendar",
        "The economics club is organizing a debate night this Friday at 5 pm",
        "Course evaluation forms open next week and will stay open for ten days",
    ],
    "General": [
        "this group is so helpful, thank you all",
        "coffee at the cafeteria is the only thing keeping me alive this week",
        "Here is a summary of the whole finance course I made, enjoy",
        "counting down the days until the holidays",
        "Found a blue notebook in room 204, left it with the secretary",
        "Wishing everyone a productive semester!",
        "My favorite subject so far is behavioral economics",
        "Congrats to the graduating class, we will miss you",
        "feeling proud, I finally understood derivatives after weeks",
        "Documentaries about the economy are really interesting, highly recommend",
        "nice weather today",
        "sharing my accounting notes in case someone needs them",
        "Good luck to everyone this semester, we can do it",
        "I think this faculty has the best professors",
        "just wanted to say hi to everyone in the group",
    ],
}

HARD = {
    "Exam": [
        "Prof just confirmed the macro midterm covers up to chapter 6 only",
        "finals schedule is posted, mine are back to back on thursday and friday",
        "Bring a scientific calculator for the stats quiz, phones are not allowed",
        "the accounting exam yesterday was brutal, the journal entries took forever",
        "Midterm marks for marketing were released this morning",
        "Closed book exam next week for business law, only the legal code is allowed",
        "we have a surprise quiz in microeconomics on Monday, the doctor just told us",
        "Past exam papers from 2023 for corporate finance are in the drive",
        "The oral exam for management will be one on one, 10 minutes each",
        "the resit for econometrics is scheduled in September",
        "Don't forget the exam hall changed, we sit in building C for the finance final",
        "The test on supply and demand will have a section of graphs to draw",
    ],
    "Assignment": [
        "need to hand in the marketing plan by sunday midnight, no extensions",
        "the doctor gave us a new case about Nokia for strategic management, due next class",
        "Our group still needs one more slide for the operations presentation",
        "excel model for the finance project must include npv and irr calculations",
        "I submitted the statistics homework 5 minutes before the deadline",
        "term paper on inflation in lebanon is due in two weeks, minimum 10 pages",
        "HW 3 of accounting is up on the platform",
        "the deadline to upload the entrepreneurship business plan was moved to friday",
        "finished my part of the group report, waiting for the others",
        "The ethics assignment should be written in APA format",
        "Presentations for organizational behavior start next Monday, check the order list",
        "Project teams for supply chain have been formed, see the sheet",
    ],
    "Question": [
        "anyone understand why the supply curve shifts when input costs rise",
        "what is the formula for the break even point",
        "need help with the depreciation question, my answer doesnt match the book",
        "does the doctor accept handwritten homework or only typed",
        "can somebody share the chapter 4 slides of marketing",
        "which one is better for studying econometrics, the textbook or the slides",
        "how many questions will be in the finance midterm",
        "is it possible to switch to another section of macro",
        "who has the stats notes from last lecture, i was sick",
        "Is anybody free to study together for the accounting final on friday",
        "what does opportunity cost mean in simple words",
        "how do I register for the summer course",
    ],
    "Announcement": [
        "Dr said no lecture on wednesday for business law, he is traveling",
        "Faculty will hold an open day on November 15, all majors are welcome",
        "new timetable is online, several classes changed rooms so check yours",
        "The administration office will be closed on Friday for maintenance",
        "scholarship applications are open until the end of the month",
        "Guest speaker from a local bank will talk about careers in finance next Tuesday",
        "Attendance in the lab sessions is now mandatory according to the faculty",
        "Class representatives meeting is held tomorrow at 1pm in the hall",
        "Marketing class is online this week, link will be sent by email",
        "The deadline to withdraw from a course is the 20th of this month",
        "Student council elections will take place next week, candidates can register at the office",
        "Parking near the faculty is restricted starting Monday",
    ],
    "General": [
        "Just want to say this group has been so helpful, thanks everyone",
        "Coffee at the cafeteria is the only thing keeping me alive this week",
        "Here is a summary of the whole finance course I made, enjoy",
        "counting down the days until the holidays",
        "Found a blue notebook in room 204, I left it with the secretary",
        "Wishing everyone a productive semester!",
        "this semester is going by so fast",
        "Feeling proud, I finally understood derivatives after weeks",
        "Lebanese economy documentaries are really interesting, highly recommend",
        "nice weather today, perfect for studying outside",
        "Congrats to the graduating class, we will miss you",
        "Sharing a free pdf of the principles of economics book",
    ],
}

ABBR = {"homework": "hw", "doctor": "dr", "tomorrow": "tmrw", "midterm": "mid", "assignment": "assignmnt"}


def noise(t):
    r = random.random()
    if r < 0.20:
        t = t.lower()
    r = random.random()
    if r < 0.20:
        t = t.rstrip(".?!")
    if random.random() < 0.10:
        words = t.split()
        i = random.randrange(len(words))
        w = words[i]
        if len(w) > 4:
            j = random.randrange(len(w) - 1)
            words[i] = w[:j] + w[j + 1] + w[j] + w[j + 2:]
        t = " ".join(words)
    if random.random() < 0.10:
        for k, v in ABBR.items():
            t = t.replace(k, v)
    return t


PER_TEMPLATE = 11
rows, seen = [], set()
for label, temps in TEMPLATES.items():
    for gi, tpl in enumerate(temps):
        gid = f"{label}_t{gi}"
        made = 0
        tries = 0
        while made < PER_TEMPLATE and tries < 200:
            tries += 1
            text = noise(fill(tpl))
            if text.lower() in seen:
                continue
            seen.add(text.lower())
            rows.append((text, label, gid))
            made += 1
for label, items in HANDWRITTEN.items():
    for i, text in enumerate(items):
        if text.lower() not in seen:
            seen.add(text.lower())
            rows.append((text, label, f"{label}_h{i}"))

# Add the student's own posts (data/my_posts.csv), each as its own group
mine_path = os.path.join(HERE, "my_posts.csv")
if os.path.exists(mine_path):
    with open(mine_path, newline="", encoding="utf-8") as f:
        for i, r in enumerate(csv.DictReader(f)):
            text = r["text"].strip()
            if text.lower() not in seen:
                seen.add(text.lower())
                rows.append((text, r["label"].strip(), f"mine_{i}"))

random.shuffle(rows)
with open(os.path.join(HERE, "posts.csv"), "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["text", "label", "group"])
    w.writerows(rows)

hard = [(t, l) for l, items in HARD.items() for t in items]
with open(os.path.join(HERE, "hard_test.csv"), "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["text", "label"])
    w.writerows(hard)

from collections import Counter
print("pool:", len(rows), dict(Counter(r[1] for r in rows)))
print("hard:", len(hard), dict(Counter(l for _, l in hard)))
