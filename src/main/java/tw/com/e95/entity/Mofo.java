package tw.com.e95.entity;

import javax.persistence.*;
import javax.validation.constraints.*;

/**
 * 攤商分類
 *
 * @author P-C Lin (a.k.a 高科技黑手)
 */
@Entity
@NamedQueries({
	@NamedQuery(name = "Mofo.findAll", query = "SELECT m FROM Mofo m")
})
@Table(catalog = "\"e95Mall\"", schema = "\"public\"", name = "\"Mofo\"", uniqueConstraints = {
	@UniqueConstraint(columnNames = {"\"name\""})
})
public class Mofo implements java.io.Serializable {

	private static final long serialVersionUID = 1L;

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Basic(optional = false)
	@Column(nullable = false, name = "\"id\"")
	private Short id;

	@Basic(optional = false)
	@NotNull
	@Size(min = 1, max = 2147483647)
	@Column(nullable = false, name = "\"name\"", length = 2147483647)
	private String name;

	/**
	 * 建構子
	 */
	public Mofo() {
	}

	/**
	 * @param id 主鍵
	 */
	protected Mofo(Short id) {
		this.id = id;
	}

	/**
	 * @param name 攤商分類名稱
	 */
	public Mofo(String name) {
		this.name = name;
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
		if (!(object instanceof Mofo)) {
			return false;
		}
		Mofo other = (Mofo) object;
		return !((this.id == null && other.id != null) || (this.id != null && !this.id.equals(other.id)));
	}

	@Override
	public String toString() {
		return "tw.com.e95.entity.Mofo[ id=" + id + " ]";
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
	 * @return 攤商分類名稱
	 */
	public String getName() {
		return name;
	}

	/**
	 * @param name 攤商分類名稱
	 */
	public void setName(String name) {
		this.name = name;
	}
}
