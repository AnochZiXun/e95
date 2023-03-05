package tw.com.e95.entity;

import javax.persistence.*;
import javax.validation.constraints.*;

/**
 * 常見問答
 *
 * @author P-C Lin (a.k.a 高科技黑手)
 */
@Entity
@NamedQueries({
	@NamedQuery(name = "FrequentlyAskedQuestion.findAll", query = "SELECT f FROM FrequentlyAskedQuestion f")
})
@Table(catalog = "\"e95Mall\"", schema = "\"public\"", name = "\"FrequentlyAskedQuestion\"")
public class FrequentlyAskedQuestion implements java.io.Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Basic(optional = false)
	@Column(nullable = false)
	private Short id;

	@Basic(optional = false)
	@NotNull
	@Size(min = 1, max = 128)
	@Column(nullable = false, length = 128)
	private String question;

	@Basic(optional = false)
	@NotNull
	@Size(min = 1, max = 65536)
	@Column(nullable = false, length = 65536)
	private String answer;

	/**
	 * 建構子
	 */
	public FrequentlyAskedQuestion() {
	}

	/**
	 * @param id 主鍵
	 */
	protected FrequentlyAskedQuestion(Short id) {
		this.id = id;
	}

	/**
	 * @param question 問題
	 * @param answer 答案
	 */
	public FrequentlyAskedQuestion(String question, String answer) {
		this.question = question;
		this.answer = answer;
	}

	@Override
	public int hashCode() {
		int hash = 0;
		hash += (id != null ? id.hashCode() : 0);
		return hash;
	}

	@Override
	public boolean equals(Object object) {
		// TODO: Warning - this method won't work in the case the id fields are not set
		if (!(object instanceof FrequentlyAskedQuestion)) {
			return false;
		}
		FrequentlyAskedQuestion other = (FrequentlyAskedQuestion) object;
		return !((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id)));
	}

	@Override
	public String toString() {
		return "tw.com.e95.entity.FrequentlyAskedQuestion[ id=" + id + " ]";
	}

	/**
	 * @return 主鍵
	 */
	public Short getId() {
		return id;
	}

	/**
	 * @param id 主鍵
	 */
	public void setId(Short id) {
		this.id = id;
	}

	/**
	 * @return 問題
	 */
	public String getQuestion() {
		return question;
	}

	/**
	 * @param question 問題
	 */
	public void setQuestion(String question) {
		this.question = question;
	}

	/**
	 * @return 答案
	 */
	public String getAnswer() {
		return answer;
	}

	/**
	 * @param answer 答案
	 */
	public void setAnswer(String answer) {
		this.answer = answer;
	}
}
